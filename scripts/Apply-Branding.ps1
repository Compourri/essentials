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

# --- functions/private/Write-WinUtilLog.ps1 ---
$logFuncPath = Join-Path $repoRoot "functions\private\Write-WinUtilLog.ps1"
if (Test-Path $logFuncPath) {
    $content = Get-Content $logFuncPath -Raw
    $newContent = $content -creplace '"winutil_\$\(Get-Date', '"essentials_$(Get-Date'
    if ($newContent -ne $content) {
        $newContent | Set-Content $logFuncPath -NoNewline
        Write-Host "  [OK] functions/private/Write-WinUtilLog.ps1" -ForegroundColor Green
    }
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

# --- functions/private/Show-WinUtilMessage.ps1 default dialog title ---
$msgFuncPath = Join-Path $repoRoot "functions\private\Show-WinUtilMessage.ps1"
if (Test-Path $msgFuncPath) {
    $content = Get-Content $msgFuncPath -Raw
    $newContent = $content -creplace '\$Title = "Winutil"', '$Title = "Essentials"'
    if ($newContent -ne $content) {
        $newContent | Set-Content $msgFuncPath -NoNewline
        Write-Host "  [OK] functions/private/Show-WinUtilMessage.ps1" -ForegroundColor Green
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

# --- docs/astro.config.mjs ---
$astroConfigPath = Join-Path $repoRoot "docs\astro.config.mjs"
if (Test-Path $astroConfigPath) {
    $content = Get-Content $astroConfigPath -Raw
    $content = $content -replace "site: 'https://winutil\.christitus\.com/'", "site: 'https://compourri.github.io/essentials/'"
    $content = $content -replace "title: 'WinUtil'", "title: 'Essentials'"
    $content = $content -replace 'https://winutil\.christitus\.com/', 'https://compourri.github.io/essentials/'
    $content = $content -replace 'https://github\.com/ChrisTitusTech/winutil', 'https://github.com/Compourri/essentials'
    $content | Set-Content $astroConfigPath -NoNewline
    Write-Host "  [OK] docs/astro.config.mjs" -ForegroundColor Green
}

# --- docs/src/site-links.ts ---
$siteLinksPath = Join-Path $repoRoot "docs\src\site-links.ts"
if (Test-Path $siteLinksPath) {
    $content = Get-Content $siteLinksPath -Raw
    $content = $content -replace 'href: ''https://christitus\.com/downloads/''', "href: 'https://github.com/Compourri/essentials/releases'"
    $content = $content -replace 'href: ''https://forum\.christitus\.com/''', "href: 'https://github.com/Compourri/essentials/discussions'"
    $content | Set-Content $siteLinksPath -NoNewline
    Write-Host "  [OK] docs/src/site-links.ts" -ForegroundColor Green
}

# --- docs/src/components/Footer.astro ---
$footerPath = Join-Path $repoRoot "docs\src\components\Footer.astro"
if (Test-Path $footerPath) {
    $content = Get-Content $footerPath -Raw
    $content = $content -replace '<a href="https://christitus\.com">Chris Titus Tech</a>', '<a href="https://compourri.co.za">Compourri</a>'
    $content | Set-Content $footerPath -NoNewline
    Write-Host "  [OK] docs/src/components/Footer.astro" -ForegroundColor Green
}

# --- docs/src/content markdown/mdx files ---
$docsContent = Join-Path $repoRoot "docs\src\content"
if (Test-Path $docsContent) {
    $mdFiles = Get-ChildItem -Path $docsContent -Include "*.md", "*.mdx" -Recurse -File
    foreach ($file in $mdFiles) {
        $content = Get-Content $file.FullName -Raw
        $original = $content

        # NOTE: -creplace is required. PowerShell's -replace is case-insensitive,
        # which would mangle lowercase "winutil" inside URLs before URL rules run.

        # GitHub URLs
        $content = $content -creplace 'https://github\.com/ChrisTitusTech/winutil', 'https://github.com/Compourri/essentials'
        $content = $content -creplace 'https://github\.com/christitustech/winutil', 'https://github.com/Compourri/essentials'

        # Shields.io badge URLs and any remaining repo-slug references
        $content = $content -creplace 'ChrisTitusTech/winutil', 'Compourri/essentials'

        # christitus.com launch commands -> compourri.co.za
        $content = $content -creplace 'irm\s+"https://christitus\.com/win"', 'irm "https://compourri.co.za/essentials"'
        $content = $content -creplace 'irm\s+https://christitus\.com/windev(?![\w.])', 'irm "https://compourri.co.za/essentials"'
        $content = $content -creplace 'irm\s+https://christitus\.com/win(?![\w.])', 'irm "https://compourri.co.za/essentials"'

        # Old WinUtil domain
        $content = $content -creplace 'winutil\.christitus\.com', 'compourri.github.io/essentials'
        $content = $content -creplace 'forum\.christitus\.com[^\s)"''<>]*', 'github.com/Compourri/essentials/discussions'
        $content = $content -creplace 'christitus\.com/windows-tool/[^\s)"''<>]*', 'compourri.co.za/'
        $content = $content -creplace 'christitus\.com', 'compourri.co.za'
        # Blanket domain swap can leave CTT-only paths; remap them to our launcher URL
        $content = $content -creplace 'compourri\.co\.za/windev(?![\w.])', 'compourri.co.za/essentials'
        $content = $content -creplace 'compourri\.co\.za/win(?![\w./-])', 'compourri.co.za/essentials'

        # User-facing WinUtil/Winutil -> Essentials in prose (case-sensitive;
        # negative lookaheads protect code identifiers like Invoke-WinUtilISO, WinUtilMessage, winutil.ps1)
        $content = $content -creplace '(?<![\w.-])WinUtil(?!\w)', 'Essentials'
        $content = $content -creplace '(?<![\w.-])Winutil(?!\w)', 'Essentials'

        if ($content -ne $original) {
            $content | Set-Content $file.FullName -NoNewline
            Write-Host "  [OK] $($file.FullName.Replace($repoRoot, ''))" -ForegroundColor Green
        }
    }
}

# --- Branded assets (canonical copies in scripts/branding-assets/) ---
$brandingAssets = Join-Path $PSScriptRoot "branding-assets"
$assetTargets = @(
    @{ Source = "favicon.svg";       Target = "docs\public\favicon.svg" },
    @{ Source = "Title-Screen.png";  Target = "docs\src\assets\branding\title-screen.png" }
)
foreach ($asset in $assetTargets) {
    $sourcePath = Join-Path $brandingAssets $asset.Source
    $targetPath = Join-Path $repoRoot $asset.Target
    if ((Test-Path $sourcePath) -and (Test-Path (Split-Path -Parent $targetPath))) {
        if (-not (Test-Path $targetPath) -or ((Get-FileHash $sourcePath).Hash -ne (Get-FileHash $targetPath).Hash)) {
            Copy-Item $sourcePath $targetPath -Force
            Write-Host "  [OK] $($asset.Target) (branded asset restored)" -ForegroundColor Green
        }
    }
}

# --- README.md ---
$readmePath = Join-Path $repoRoot "README.md"
if (Test-Path $readmePath) {
    $content = Get-Content $readmePath -Raw
    # Fix image paths broken by upstream doc restructures (Hugo/Astro moves)
    $content = $content -creplace '\(/docs/assets/images/Title-Screen\.png\)', '(docs/src/assets/branding/title-screen.png)'
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
    # Keep the upstream acknowledgment pointing at ChrisTitusTech/winutil (re-branding rules above rewrite it)
    $content = $content -replace 'This project is a fork of .*?Thanks to Chris Titus and', "This project is a fork of [Chris Titus Tech's Windows Utility](https://github.com/ChrisTitusTech/winutil). Thanks to Chris Titus and"
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
