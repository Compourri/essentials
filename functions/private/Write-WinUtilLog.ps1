function Write-WinUtilLog {
    <#

    .SYNOPSIS
        Writes a timestamped WinUtil log entry to the active session log.

    .DESCRIPTION
        Called from the interface thread and from every job body. The structured log is a
        silent file record (named mutex serializes direct appends) on a different file from
        the Start-Transcript console capture, since the transcript locks its file exclusively.
        INFO entries stay out of the terminal to keep the CLI a clean console record of
        user-facing output; WARN and ERROR still echo through the host so they are visible
        and captured by the transcript. When the transcript owns the active session log
        (legacy single-file mode), entries go through the host for the same reason.

    .PARAMETER Message
        The message to write.

    .PARAMETER Level
        The severity level for the log entry.

    .PARAMETER Component
        The WinUtil component producing the log entry.

    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [ValidateSet("INFO", "WARN", "ERROR", "DEBUG")]
        [string]$Level = "INFO",

        [string]$Component = "WinUtil",

        # Continuation of an error already counted, such as a stack frame
        [switch]$Detail
    )

    # UI performance diagnostics are useful to developers but are too noisy for the release
    # transcript. Compile.ps1 stamps local builds so DEBUG output cannot leak into CI artifacts.
    if ($Level -eq "DEBUG" -and ($null -eq $sync -or -not $sync.IsLocalCompile)) {
        return
    }

    if ($Level -eq "ERROR" -and -not $Detail -and $null -ne $sync.LoggedErrors) {
        $null = $sync.LoggedErrors.Add("[$Component] $Message")
    }

    # Global scope is per runspace, so this counter only ever sees errors logged by the
    # runspace that owns it: a job worker reads its own, and a tweak on the UI thread reads the
    # UI thread's
    if ($Level -eq "ERROR" -and -not $Detail) {
        $global:WinUtilJobErrorCount++
    }

    try {
        $logPath = $null
        $transcriptPath = $null
        if ($null -ne $sync -and $sync.ContainsKey("logPath")) {
            $logPath = $sync.logPath
        }

        if ($null -ne $sync -and $sync.ContainsKey("transcriptPath")) {
            $transcriptPath = $sync.transcriptPath
        }

        if ([string]::IsNullOrWhiteSpace($logPath) -and -not [string]::IsNullOrWhiteSpace($transcriptPath)) {
            $logPath = $transcriptPath
        }

        if ([string]::IsNullOrWhiteSpace($logPath) -and $null -ne $sync -and $sync.ContainsKey("winutildir")) {
            $logDirectory = Join-Path $sync.winutildir "logs"
            $logPath = Join-Path $logDirectory "essentials_$(Get-Date -Format "yyyy-MM-dd_HH-mm-ss").log"
            $sync.logPath = $logPath
        }

        if ([string]::IsNullOrWhiteSpace($logPath) -and -not [string]::IsNullOrWhiteSpace($env:LocalAppData)) {
            if ([string]::IsNullOrWhiteSpace($script:WinUtilLogPath)) {
                $logDirectory = Join-Path (Join-Path $env:LocalAppData "winutil") "logs"
                $script:WinUtilLogPath = Join-Path $logDirectory "essentials_$(Get-Date -Format "yyyy-MM-dd_HH-mm-ss").log"
            }
            $logPath = $script:WinUtilLogPath
        }

        if ([string]::IsNullOrWhiteSpace($logPath)) {
            return
        }

        $logDirectory = Split-Path -Path $logPath -Parent
        if (-not (Test-Path $logDirectory)) {
            New-Item -Path $logDirectory -ItemType Directory -Force | Out-Null
        }

        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"
        $line = "[$timestamp] [$Level] [$Component] $Message"

        # INFO stays out of the terminal (and its transcript); the terminal stays a clean
        # console record of user-facing output. WARN/ERROR still echo so they are visible.
        # DEBUG echoes only when explicitly asked for via ESSENTIALS_DEBUG.
        $echoToConsole = ($Level -eq "WARN" -or $Level -eq "ERROR") -or `
            ($Level -eq "DEBUG" -and -not [string]::IsNullOrWhiteSpace($env:ESSENTIALS_DEBUG))

        if (-not [string]::IsNullOrWhiteSpace($transcriptPath) -and $logPath -eq $transcriptPath) {
            # Legacy single-file mode: Start-Transcript locks its file exclusively, so a
            # direct append would throw. Echo the user-facing levels through the host so
            # the transcript captures them; INFO has no silent channel here by design.
            if ($echoToConsole) {
                Write-Host $line
            }
            return
        }

        $mutex = [System.Threading.Mutex]::new($false, "WinUtilSessionLog")
        $held = $false
        try {
            try {
                $held = $mutex.WaitOne(2000)
            } catch [System.Threading.AbandonedMutexException] {
                # A thread died holding the mutex; ownership transfers to us either way
                $held = $true
            }

            if (-not $held) {
                # Writing anyway is what interleaves lines, and the wait only times out when
                # contention is at its worst. Still keep INFO out of the terminal.
                if ($echoToConsole) {
                    Write-Host $line
                }
                return
            }

            Add-Content -Path $logPath -Value $line -Encoding UTF8 -ErrorAction Stop
            if ($echoToConsole) {
                Write-Host $line
            }
        } catch [System.IO.IOException] {
            if ($echoToConsole) {
                Write-Host $line
            }
        } finally {
            if ($held) { $mutex.ReleaseMutex() }
            $mutex.Dispose()
        }
    } catch {
        Write-Warning "Unable to write WinUtil log entry: $($_.Exception.Message)"
    }
}
