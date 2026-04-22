Function Install-WinUtilProgramWinget {
    <#
    .SYNOPSIS
    Runs the designated action on the provided programs using Winget

    .PARAMETER Programs
    A list of programs to process

    .PARAMETER action
    The action to perform on the programs, can be either 'Install' or 'Uninstall'

    .NOTES
    The triple quotes are required any time you need a " in a normal script block.
    The winget Return codes are documented here: https://github.com/microsoft/winget-cli/blob/master/doc/windows/package-actionr/winget/returnCodes.md
    #>

    param(
        [Parameter(Mandatory, Position=0)]$Programs,

        [Parameter(Mandatory, Position=1)]
        [ValidateSet("Install", "Uninstall")]
        [String]$Action
    )

    Function Invoke-Winget {
    <#
    .SYNOPSIS
    Invokes the winget.exe with the provided arguments and return the exit code

    .PARAMETER wingetId
    The Id of the Program that Winget should Install/Uninstall

    .PARAMETER source
    The source to use for the package

    .NOTES
    Invoke Winget uses the public variable $Action defined outside the function to determine if a Program should be installed or removed
    #>
        param (
            [string]$wingetId,
            [string]$source = "winget"
        )

        $commonArguments = "--id $wingetId --silent"
        $arguments = if ($Action -eq "Install") {
            "install $commonArguments --accept-source-agreements --accept-package-agreements --source $source"
        } else {
            "uninstall $commonArguments --source $source"
        }

        $processParams = @{
            FilePath = "winget"
            ArgumentList = $arguments
            Wait = $true
            PassThru = $true
            NoNewWindow = $true
        }

        return (Start-Process @processParams).ExitCode
    }

    Function Invoke-Install {
    <#
    .SYNOPSIS
    Contains the Install Logic and return code handling from winget

    .PARAMETER Program
    The Program object with id and source information that should be installed

     .NOTES
    #>
        param (
            [psobject]$Program
        )
        $status = Invoke-Winget -wingetId $Program.id -source $Program.source
        if ($status -eq 0) {
            Write-Host "$($Program.id) installed successfully."
            return $true
        } elseif ($status -eq -1978335189) {
            Write-Host "$($Program.id) No applicable update found"
            return $true
        }

        Write-Host "Failed to install $($Program.id)."
        return $false
    }

    Function Invoke-Uninstall {
        <#
        .SYNOPSIS
        Contains the Uninstall Logic and return code handling from winget

        .PARAMETER Program
        The Program object with id and source that should be uninstalled
        #>
        param (
            [psobject]$Program
        )

        try {
            $status = Invoke-Winget -wingetId $Program.id -source $Program.source
            if ($status -eq 0) {
                Write-Host "$($Program.id) uninstalled successfully."
                return $true
            } else {
                Write-Host "Failed to uninstall $($Program.id)."
                return $false
            }
        } catch {
            Write-Host "Failed to uninstall $($Program.id) due to an error: $_"
            return $false
        }
    }

    $count = $Programs.Count
    $failedPackages = @()

    Write-Host "==========================================="
    Write-Host "--    Configuring winget packages       ---"
    Write-Host "==========================================="

    for ($i = 0; $i -lt $count; $i++) {
        $Program = $Programs[$i]
        $result = $false
        Set-WinUtilProgressBar -label "$Action $($Program.id)" -percent ($i / $count * 100)
        Invoke-WPFUIThread -ScriptBlock{ Set-WinUtilTaskbaritem -value ($i / $count)}

        $result = switch ($Action) {
            "Install" {Invoke-Install -Program $Program}
            "Uninstall" {Invoke-Uninstall -Program $Program}
            default {throw "[Install-WinUtilProgramWinget] Invalid action: $Action"}
        }

        if (-not $result) {
            $failedPackages += $Program.id
        }
    }

    Set-WinUtilProgressBar -label "$($Action)action done" -percent 100
    return $failedPackages
}
