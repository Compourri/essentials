function Invoke-WinUtilInstallPSProfile {

    if (Test-Path $Profile) {
        Rename-Item $Profile -NewName ($Profile + '.bak')
    }

    Start-Process powershell -ArgumentList '-Command "irm https://github.com/Compourri/powershell-profile/raw/main/setup.ps1 | iex"'
}
