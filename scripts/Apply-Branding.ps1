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
    $content = $content -replace '"WinUtil"', '"Essentials"'

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
    $content = $content -replace 'managed by WinUtil\.', 'managed by Essentials.'
    $content = $content -replace 'applied by WinUtil', 'applied by Essentials'
    $content = $content -replace 'undo WinUtil update policies', 'undo Essentials update policies'
    $content = $content -replace 'Change the WinUtil UI Theme', 'Change the Essentials UI Theme'
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

# --- config/themes.json ---
$themesPath = Join-Path $repoRoot "config\themes.json"
if (Test-Path $themesPath) {
    $content = Get-Content $themesPath -Raw
    $content = $content -replace '"HeaderFontFamily": "Consolas, Monaco"', '"HeaderFontFamily": "Segoe UI Variable, Segoe UI"'
    $content = $content -replace '"ProgressBarForegroundColor": "#2E77FF"', '"ProgressBarForegroundColor": "#EEEE22"'
    $content = $content -replace '"ToggleButtonOnColor": "#2E77FF"', '"ToggleButtonOnColor": "#EEEE22"'
    $content = $content -replace '"LabelboxForegroundColor": "#5BDCFF"', '"LabelboxForegroundColor": "#EEEE22"'
    $content = $content -replace '"LinkForegroundColor": "#ADD8E6"', '"LinkForegroundColor": "#EEEE22"'
    $content = $content -replace '"ScrollBarHoverColor": "#3B4252"', '"ScrollBarHoverColor": "#EEEE22"'
    $content = $content -replace '"ScrollBarDraggingColor": "#5E81AC"', '"ScrollBarDraggingColor": "#EEEE22"'
    $content = $content -replace '"ProgressBarForegroundColor": "#6EFF72"', '"ProgressBarForegroundColor": "#EEEE22"'
    $content = $content -replace '"ComboBoxBackgroundColor": "#1E3747"', '"ComboBoxBackgroundColor": "#2F2F2F"'
    $content = $content -replace '"ButtonBackgroundColor": "#1E3747"', '"ButtonBackgroundColor": "#2F2F2F"'
    $content = $content -replace '"ButtonBackgroundPressedColor": "#F7F7F7"', '"ButtonBackgroundPressedColor": "#EEEE22"'
    $content = $content -replace '"ButtonBackgroundMouseoverColor": "#3B4252"', '"ButtonBackgroundMouseoverColor": "#222222"'
    $content = $content -replace '"ButtonBackgroundSelectedColor": "#5E81AC"', '"ButtonBackgroundSelectedColor": "#80EEEE22"'
    $content | Set-Content $themesPath -NoNewline
    Write-Host "  [OK] config/themes.json" -ForegroundColor Green
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
    "Invoke-WPFUnInstall.ps1",
    "Invoke-WPFAppxInstall.ps1",
    "Invoke-WPFAppxRemoval.ps1",
    "Invoke-WPFOOSU.ps1"
)

foreach ($file in $MessageBoxFiles) {
    $filePath = Join-Path $repoRoot "functions\public\$file"
    if (Test-Path $filePath) {
        $content = Get-Content $filePath -Raw
        $newContent = $content -replace '"Winutil"', '"Essentials"' -replace '"WinUtil"', '"Essentials"'
        if ($newContent -ne $content) {
            $newContent | Set-Content $filePath -NoNewline
            Write-Host "  [OK] functions/public/$file" -ForegroundColor Green
        }
    }
}

# --- functions/public/Invoke-WPFUpdatesdefault.ps1 ---
$updatesPath = Join-Path $repoRoot "functions\public\Invoke-WPFUpdatesdefault.ps1"
if (Test-Path $updatesPath) {
    $content = Get-Content $updatesPath -Raw
    $content = $content -replace 'managed by WinUtil', 'managed by Essentials'
    $content = $content -replace "WinUtil's legacy", "Essentials' legacy"
    $content | Set-Content $updatesPath -NoNewline
    Write-Host "  [OK] functions/public/Invoke-WPFUpdatesdefault.ps1" -ForegroundColor Green
}

# --- PowerShell Profile functions ---
$psProfileInstall = Join-Path $repoRoot "functions\private\Invoke-WinUtilInstallPSProfile.ps1"
if (Test-Path $psProfileInstall) {
    $content = Get-Content $psProfileInstall -Raw
    $content = $content -replace 'ChrisTitusTech/powershell-profile', 'Compourri/powershell-profile'
    $content | Set-Content $psProfileInstall -NoNewline
    Write-Host "  [OK] functions/private/Invoke-WinUtilInstallPSProfile.ps1" -ForegroundColor Green
}

$psProfileUninstall = Join-Path $repoRoot "functions\private\Invoke-WinUtilUninstallPSProfile.ps1"
if (Test-Path $psProfileUninstall) {
    $content = Get-Content $psProfileUninstall -Raw
    $content = $content -replace 'CTT PowerShell Profile', 'Compourri PowerShell Profile'
    $content | Set-Content $psProfileUninstall -NoNewline
    Write-Host "  [OK] functions/private/Invoke-WinUtilUninstallPSProfile.ps1" -ForegroundColor Green
}

# --- config/feature.json (PowerShell Profile entries) ---
$featurePath = Join-Path $repoRoot "config\feature.json"
if (Test-Path $featurePath) {
    $content = Get-Content $featurePath -Raw
    $content = $content -replace 'CTT PowerShell Profile', 'PowerShell Profile'
    $content = $content -replace 'ChrisTitusTech/powershell-profile', 'Compourri/powershell-profile'
    $content | Set-Content $featurePath -NoNewline
    Write-Host "  [OK] config/feature.json (PS Profile)" -ForegroundColor Green
}

# --- docs/hugo.toml ---
$hugoPath = Join-Path $repoRoot "docs\hugo.toml"
if (Test-Path $hugoPath) {
    $content = Get-Content $hugoPath -Raw
    $content = $content -replace 'title\s*=\s*"WinUtil Documentation"', 'title = "Essentials Documentation"'
    $content = $content -replace 'https://github.com/christitustech/winutil', 'https://github.com/Compourri/essentials'
    $content = $content -replace 'https://github.com/ChrisTitusTech/winutil', 'https://github.com/Compourri/essentials'
    $content | Set-Content $hugoPath -NoNewline
    Write-Host "  [OK] docs/hugo.toml" -ForegroundColor Green
}

# --- docs/i18n/en.yaml ---
$i18nPath = Join-Path $repoRoot "docs\i18n\en.yaml"
if (Test-Path $i18nPath) {
    $content = Get-Content $i18nPath -Raw
    $content = $content -replace "href='https://christitus.com'>Chris Titus Tech", "href='https://compourri.co.za'>Compourri"
    $content | Set-Content $i18nPath -NoNewline
    Write-Host "  [OK] docs/i18n/en.yaml" -ForegroundColor Green
}

# --- docs/content/ markdown files ---
$docsContent = Join-Path $repoRoot "docs\content"
if (Test-Path $docsContent) {
    $mdFiles = Get-ChildItem -Path $docsContent -Filter "*.md" -Recurse -File
    foreach ($file in $mdFiles) {
        $content = Get-Content $file.FullName -Raw
        $original = $content

        # User-facing WinUtil/Winutil → Essentials (but NOT inside code blocks or function names)
        # Replace standalone "WinUtil" and "Winutil" in prose text
        $content = $content -replace '(?<!\w)WinUtil(?!\w|\.ps1|_|Functions| variables| checkboxes| program| winget| choco| ISO| SSHServer| ExplorerUpdate| currentSystem| Message| Log| File| TweaksProgress| Taskbaritem)', 'Essentials'
        $content = $content -replace '(?<!\w)Winutil(?!\w|\.ps1|_|Functions| variables| checkboxes| program| winget| choco| ISO| SSHServer| ExplorerUpdate| currentSystem| Message| Log| File| TweaksProgress| Taskbaritem)', 'Essentials'

        # GitHub URLs
        $content = $content -replace 'https://github\.com/ChrisTitusTech/winutil', 'https://github.com/Compourri/essentials'
        $content = $content -replace 'https://github\.com/christitustech/winutil', 'https://github.com/Compourri/essentials'

        # Shields.io badge URLs
        $content = $content -replace 'ChrisTitusTech/winutil', 'Compourri/essentials'

        # christitus.com launch commands → compourri.co.za
        $content = $content -replace 'irm\s+"https://christitus\.com/win"', 'irm "https://compourri.co.za/essentials"'
        $content = $content -replace "irm\s+`"https://christitus\.com/win`"", 'irm "https://compourri.co.za/essentials"'

        # Old WinUtil domain
        $content = $content -replace 'winutil\.christitus\.com', 'compourri.github.io/essentials'

        if ($content -ne $original) {
            $content | Set-Content $file.FullName -NoNewline
            Write-Host "  [OK] $($file.FullName.Replace($repoRoot, ''))" -ForegroundColor Green
        }
    }
}

# --- README.md ---
$readmePath = Join-Path $repoRoot "README.md"
if (Test-Path $readmePath) {
    $content = Get-Content $readmePath -Raw
    $content = $content -replace 'ChrisTitusTech/winutil', 'Compourri/essentials'
    $content = $content -replace 'https://github\.com/ChrisTitusTech/winutil', 'https://github.com/Compourri/essentials'
    $content = $content -replace 'irm\s+https://christitus\.com/win\s*\|\s*iex', 'irm https://compourri.co.za/essentials | iex'
    $content = $content -replace 'irm\s+https://christitus\.com/windev\s*\|\s*iex', 'irm https://compourri.co.za/essentials | iex'
    $content = $content -replace 'irm\s+`"https://christitus\.com/win`"\s*\|\s*iex', 'irm "https://compourri.co.za/essentials" | iex'
    $content = $content -replace 'irm\s+`"https://christitus\.com/windev`"\s*\|\s*iex', 'irm "https://compourri.co.za/essentials" | iex'
    $content = $content -replace 'https://winutil\.christitus\.com', 'https://compourri.github.io/essentials'
    $content = $content -replace 'christitus\.com/windows-tool/', 'compourri.co.za/'
    $content = $content -replace 'discord\.gg/RUbZUZyByQ', ''
    $content = $content -replace '\[Discord\]\([^)]*\)\s*', ''
    $content = $content -replace 'cttstore\.com/windows-toolbox', ''
    $content = $content -replace '\[.*?EXE Wrapper.*?\]\([^)]*\)', ''
    $content = $content -replace '(?<!\w)WinUtil(?!\w|\.ps1|_)', 'Essentials'
    $content | Set-Content $readmePath -NoNewline
    Write-Host "  [OK] README.md" -ForegroundColor Green
}

Write-Host ""
Write-Host "Branding patches applied successfully!" -ForegroundColor Cyan
Write-Host "Review changes with: git diff" -ForegroundColor Yellow

# --- Remove files that should not exist in our fork ---
$filesToRemove = @(
    "docs\static\CNAME",
    ".github\CODE_OF_CONDUCT.md",
    ".github\CONTRIBUTING.md"
)
foreach ($file in $filesToRemove) {
    $filePath = Join-Path $repoRoot $file
    if (Test-Path $filePath) {
        Remove-Item $filePath -Force
        Write-Host "  [OK] Removed $file" -ForegroundColor Green
    }
}
