<#
.SYNOPSIS
    Applies Compourri branding patches after merging upstream changes.
.DESCRIPTION
    Run this script after merging upstream changes from ChrisTitusTech/winutil
    to restore Compourri branding in user-facing text.
.NOTES
    Author: George van der Westhuizen @Compourri
#>

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot

Write-Host "Applying Compourri branding patches..." -ForegroundColor Cyan

# --- scripts/start.ps1 ---
$startPath = Join-Path $repoRoot "scripts\start.ps1"
if (Test-Path $startPath) {
    $content = Get-Content $startPath -Raw

    # Author line
    $content = $content -replace 'Author\s+:\s*Chris Titus @ChrisTitusTech', 'Author         : George van der Westhuizen @Compourri'
    $content = $content -replace 'GitHub\s+:\s*https://github.com/ChrisTitusTech/winutil', 'GitHub         : https://github.com/Compourri'

    # Error messages
    $content = $content -replace '"WinUtil is unable to run', '"Essentials is unable to run'
    $content = $content -replace '"Winutil needs to be run as Administrator', '"Essentials needs to be run as Administrator'

    # Log file name
    $content = $content -replace 'winutil_\$dateTime\.log', 'essentials_$dateTime.log'

    # Window title
    $content = $content -replace '"WinUtil \(Admin\)"', '"Software Essentials (Admin)"'

    $content | Set-Content $startPath -NoNewline
    Write-Host "  [OK] scripts/start.ps1" -ForegroundColor Green
}

# --- scripts/main.ps1 ---
$mainPath = Join-Path $repoRoot "scripts\main.ps1"
if (Test-Path $mainPath) {
    $content = Get-Content $mainPath -Raw

    $content = $content -replace '"Quitting winutil\.\.\."', '"Quitting Essentials..."'
    $content = $content -replace '"WinUtil lost focus"', '"Software Essentials lost focus"'

    # About dialog author block
    $content = $content -replace 'Author\s+:\s*<a href="https://github.com/ChrisTitusTech">@christitustech</a>', 'Author   : <a href="https://github.com/Compourri">@compourri</a>'
    $content = $content -replace 'GitHub\s+:\s*<a href="https://github.com/ChrisTitusTech/winutil">ChrisTitusTech/winutil</a>', 'GitHub   : <a href="https://github.com/Compourri/essentials">Compourri/essentials</a>'
    $content = $content -replace 'Version\s+:\s*<a href="https://github.com/ChrisTitusTech/winutil/releases/tag/', 'Version  : <a href="https://github.com/Compourri/essentials/releases/tag/'

    $content | Set-Content $mainPath -NoNewline
    Write-Host "  [OK] scripts/main.ps1" -ForegroundColor Green
}

# --- xaml/inputXML.xaml ---
$xamlPath = Join-Path $repoRoot "xaml\inputXML.xaml"
if (Test-Path $xamlPath) {
    $content = Get-Content $xamlPath -Raw
    $content = $content -replace 'Title="WinUtil"', 'Title="Software Essentials"'
    $content | Set-Content $xamlPath -NoNewline
    Write-Host "  [OK] xaml/inputXML.xaml" -ForegroundColor Green
}

# --- functions/private/Show-CustomDialog.ps1 ---
$dialogPath = Join-Path $repoRoot "functions\private\Show-CustomDialog.ps1"
if (Test-Path $dialogPath) {
    $content = Get-Content $dialogPath -Raw
    $content = $content -replace '\.Text\s*=\s*"WinUtil"', '.Text = "Compourri Software Essentials"'
    $content | Set-Content $dialogPath -NoNewline
    Write-Host "  [OK] functions/private/Show-CustomDialog.ps1" -ForegroundColor Green
}

# --- functions/public/Show-CompourriLogo.ps1 ---
$logoPath = Join-Path $repoRoot "functions\public\Show-CompourriLogo.ps1"
if (Test-Path $logoPath) {
    $content = Get-Content $logoPath -Raw
    $content = $content -replace '=== WinUtil ===', '=== Compourri Software Essentials ==='
    $content | Set-Content $logoPath -NoNewline
    Write-Host "  [OK] functions/public/Show-CompourriLogo.ps1" -ForegroundColor Green
}

# --- functions/public/Invoke-WPFButton.ps1 ---
$buttonPath = Join-Path $repoRoot "functions\public\Invoke-WPFButton.ps1"
if (Test-Path $buttonPath) {
    $content = Get-Content $buttonPath -Raw
    $content = $content -replace '"Chris Titus Tech''s Windows Utility"', '"Compourri Software Essentials"'
    $content | Set-Content $buttonPath -NoNewline
    Write-Host "  [OK] functions/public/Invoke-WPFButton.ps1" -ForegroundColor Green
}

# --- config/tweaks.json ---
$tweaksPath = Join-Path $repoRoot "config\tweaks.json"
if (Test-Path $tweaksPath) {
    $content = Get-Content $tweaksPath -Raw
    $content = $content -replace 'WinUtil modifications', 'Software Essentials modifications'
    $content = $content -replace 'created by WinUtil', 'created by Software Essentials'
    $content | Set-Content $tweaksPath -NoNewline
    Write-Host "  [OK] config/tweaks.json" -ForegroundColor Green
}

# --- MessageBox titles in functions/public/*.ps1 ---
$publicFunctions = Join-Path $repoRoot "functions\public\*.ps1"
$MessageBoxFiles = @(
    "Invoke-WPFFeatureInstall.ps1",
    "Invoke-WPFInstall.ps1",
    "Invoke-WPFGetInstalled.ps1",
    "Invoke-WPFInstallUpgrade.ps1",
    "Invoke-WPFtweaksbutton.ps1",
    "Invoke-WPFundoall.ps1",
    "Invoke-WPFUnInstall.ps1"
)

foreach ($file in $MessageBoxFiles) {
    $filePath = Join-Path $repoRoot "functions\public\$file"
    if (Test-Path $filePath) {
        $content = Get-Content $filePath -Raw
        $newContent = $content -replace '"Winutil"', '"Essentials"'
        if ($newContent -ne $content) {
            $newContent | Set-Content $filePath -NoNewline
            Write-Host "  [OK] functions/public/$file" -ForegroundColor Green
        }
    }
}

Write-Host ""
Write-Host "Branding patches applied successfully!" -ForegroundColor Cyan
Write-Host "Review changes with: git diff" -ForegroundColor Yellow
