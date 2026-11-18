function Get-WinUtilSelectedPackages {

     param(
         [Parameter(Mandatory = $true)]
         [object] $PackageList,

         [Parameter(Mandatory = $true)]
         [string] $Preference,

         [ValidateSet("Install", "Uninstall")]
         [string] $Action = "Install"
     )

    # A single package has no meaningful percentage to show
    if ($PackageList.count -eq 1) {
        Step-WinUtilJob -State "Indeterminate"
    }

    $packagesWinget = [System.Collections.ArrayList]::new()
    $packagesChoco = [System.Collections.ArrayList]::new()
    $packagesUnresolved = [System.Collections.ArrayList]::new()
    $packages = @{
        Winget = $packagesWinget
        Choco = $packagesChoco
        Unresolved = $packagesUnresolved
    }

    function Test-PackageIdUsable {
        param($PackageId)

        return -not ([string]::IsNullOrWhiteSpace([string]$PackageId) -or $PackageId -eq "na")
    }

    function Get-PackageDisplayName {
        param($Package)

        $displayName = @($Package.Name, $Package.content, $Package.Description, $Package.winget, $Package.choco) |
            Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) -and $_ -ne "na" } |
            Select-Object -First 1

        if ([string]::IsNullOrWhiteSpace([string]$displayName)) {
            return "Unknown package"
        }

        return [string]$displayName
    }

    function Add-UnresolvedPackage {
        param($Package, [string]$Detail)

        $displayName = Get-PackageDisplayName -Package $Package
        if (-not $packagesUnresolved.Contains($displayName)) {
            $null = $packagesUnresolved.Add([pscustomobject]@{
                Name = $displayName
                Detail = $Detail
            })
        }
    }

    function Add-PackageId {
        param(
            [System.Collections.ArrayList]$Target,
            $PackageId
        )

        # A config field may hold several IDs separated by ";" (e.g. a dependency;the package).
        # Detection splits the same way, so install and detection agree on what gets installed.
        $ids = [string]$PackageId -split ";"
        if ($Action -eq "Uninstall") {
            # Detection identifies the last ID as the app; preceding IDs are dependencies.
            $ids = @($ids[-1])
        }
        foreach ($id in $ids) {
            $id = $id.Trim()
            if ([string]::IsNullOrWhiteSpace($id) -or $id -eq "na") {
                continue
            }

            if (-not $Target.Contains($id)) {
                $null = $Target.Add($id)
            }
        }
    }

    foreach ($package in $PackageList) {
        switch ($Preference) {
            "Choco" {
                if (Test-PackageIdUsable -PackageId $package.choco) {
                    Add-PackageId -Target $packagesChoco -PackageId $package.choco
                } elseif (Test-PackageIdUsable -PackageId $package.winget) {
                    Add-PackageId -Target $packagesWinget -PackageId $package.winget
                } else {
                    Add-UnresolvedPackage -Package $package -Detail "no Chocolatey or WinGet package id is configured"
                }
            }
            "Winget" {
                if (Test-PackageIdUsable -PackageId $package.winget) {
                    Add-PackageId -Target $packagesWinget -PackageId $package.winget
                } elseif (Test-PackageIdUsable -PackageId $package.choco) {
                    Add-UnresolvedPackage -Package $package -Detail "no WinGet package id is configured; it is available via Chocolatey as '$($package.choco)' - switch the package manager preference to Chocolatey"
                } else {
                    Add-UnresolvedPackage -Package $package -Detail "no WinGet or Chocolatey package id is configured"
                }
            }
            default {
                Add-UnresolvedPackage -Package $package -Detail "unsupported package manager preference '$Preference'"
            }
        }
    }

    return $packages
}
