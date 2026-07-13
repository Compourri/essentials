# Visual Refresh Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refresh the WPF UI with Windows 11 visual language — Mica material, rounded controls, updated palette, refined typography — with Win10 fallback.

**Architecture:** Hybrid approach — detect Win11 22H2+ at startup and enable real Mica via `DwmSetWindowAttribute`; Win10 uses solid theme colors. All other visual changes (rounded corners, color palette, typography) apply on both. The theme system in `themes.json` drives all visual properties; the XAML references these as DynamicResources. A new `Enable-Win11Mica.ps1` private function handles OS detection and P/Invoke.

**Tech Stack:** PowerShell, WPF/XAML, Win32 interop (P/Invoke via `Add-Type`)

## Global Constraints

- Win10 compatibility must not break — Mica is Win11-only, all other changes apply on both
- All corner radii and spacing values go in `themes.json` (shared section) for easy tweaking
- XAML structural layout (grid, tab control, row definitions) stays unchanged
- The existing `DynamicResource` binding pattern must be preserved
- No new external dependencies or NuGet packages

---

### Task 1: Update themes.json with Windows 11 Color Palette

**Files:**
- Modify: `config/themes.json` — full file rewrite

**Interfaces:**
- Consumes: (none)
- Produces: `themes.json` with new color values and shared corner-radius/sizing entries

- [ ] **Step 1: Write the updated themes.json**

```json
{
  "shared": {
    "AppEntryWidth": "200",
    "AppEntryFontSize": "11",
    "AppEntryMargin": "1,0,1,0",
    "AppEntryBorderThickness": "0",
    "CustomDialogFontSize": "12",
    "CustomDialogFontSizeHeader": "14",
    "CustomDialogWidth": "400",
    "CustomDialogHeight": "200",
    "FontSize": "12",
    "FontFamily": "Arial",
    "HeaderFontSize": "18",
    "HeaderFontFamily": "Segoe UI Variable, Segoe UI",
    "CheckBoxBulletDecoratorSize": "14",
    "CheckBoxMargin": "15,0,0,2",
    "TabContentMargin": "5",
    "TabButtonFontSize": "14",
    "TabButtonWidth": "110",
    "TabButtonHeight": "26",
    "TabRowHeightInPixels": "50",
    "ToolTipWidth": "300",
    "IconFontSize": "14",
    "IconButtonSize": "35",
    "SettingsIconFontSize": "18",
    "CloseIconFontSize": "18",
    "GroupBorderBackgroundColor": "#2D2D2D",
    "ButtonFontSize": "12",
    "ButtonFontFamily": "Arial",
    "ButtonWidth": "200",
    "ButtonHeight": "25",
    "ConfigTabButtonFontSize": "14",
    "ConfigUpdateButtonFontSize": "14",
    "SearchBarWidth": "200",
    "SearchBarHeight": "26",
    "SearchBarTextBoxFontSize": "12",
    "SearchBarClearButtonFontSize": "14",
    "CheckboxMouseOverColor": "#999999",
    "ButtonBorderThickness": "1",
    "ButtonMargin": "1",
    "ButtonCornerRadius": "6"
  },
  "Light": {
    "AppInstallUnselectedColor": "#F0F0F0",
    "AppInstallHighlightedColor": "#E0E0E0",
    "AppInstallSelectedColor": "#D0D0D0",
    "AppInstallOverlayBackgroundColor": "#6A6D72",
    "ComboBoxForegroundColor": "#1A1A1A",
    "ComboBoxBackgroundColor": "#60CDFF",
    "LabelboxForegroundColor": "#1A1A1A",
    "MainForegroundColor": "#1A1A1A",
    "MainBackgroundColor": "#FFFFFF",
    "LabelBackgroundColor": "#F0F0F0",
    "LinkForegroundColor": "#60CDFF",
    "LinkHoverForegroundColor": "#1A1A1A",
    "ScrollBarBackgroundColor": "#C0C0C0",
    "ScrollBarHoverColor": "#60CDFF",
    "ScrollBarDraggingColor": "#60CDFF",
    "ProgressBarForegroundColor": "#60CDFF",
    "ProgressBarBackgroundColor": "Transparent",
    "ProgressBarTextColor": "#1A1A1A",
    "ButtonInstallBackgroundColor": "#E8E8E8",
    "ButtonTweaksBackgroundColor": "#E8E8E8",
    "ButtonConfigBackgroundColor": "#E8E8E8",
    "ButtonUpdatesBackgroundColor": "#E8E8E8",
    "ButtonWin11ISOBackgroundColor": "#E8E8E8",
    "ButtonInstallForegroundColor": "#1A1A1A",
    "ButtonTweaksForegroundColor": "#1A1A1A",
    "ButtonConfigForegroundColor": "#1A1A1A",
    "ButtonUpdatesForegroundColor": "#1A1A1A",
    "ButtonWin11ISOForegroundColor": "#1A1A1A",
    "ButtonBackgroundColor": "#E8E8E8",
    "ButtonBackgroundPressedColor": "#60CDFF",
    "ButtonBackgroundMouseoverColor": "#D0D0D0",
    "ButtonBackgroundSelectedColor": "#F0F0F0",
    "ButtonForegroundColor": "#1A1A1A",
    "ToggleButtonOnColor": "#60CDFF",
    "ToggleButtonOffColor": "#666666",
    "ToolTipBackgroundColor": "#F0F0F0",
    "BorderColor": "#E0E0E0",
    "BorderOpacity": "0.2"
  },
  "Dark": {
    "AppInstallUnselectedColor": "#2D2D2D",
    "AppInstallHighlightedColor": "#383838",
    "AppInstallSelectedColor": "#404040",
    "AppInstallOverlayBackgroundColor": "#2E3135",
    "ComboBoxForegroundColor": "#F7F7F7",
    "ComboBoxBackgroundColor": "#404040",
    "LabelboxForegroundColor": "#60CDFF",
    "MainForegroundColor": "#F7F7F7",
    "MainBackgroundColor": "#1E1E1E",
    "LabelBackgroundColor": "#2D2D2D",
    "LinkForegroundColor": "#60CDFF",
    "LinkHoverForegroundColor": "#F7F7F7",
    "ScrollBarBackgroundColor": "#505050",
    "ScrollBarHoverColor": "#60CDFF",
    "ScrollBarDraggingColor": "#60CDFF",
    "ProgressBarForegroundColor": "#60CDFF",
    "ProgressBarBackgroundColor": "Transparent",
    "ProgressBarTextColor": "#F7F7F7",
    "ButtonInstallBackgroundColor": "#2D2D2D",
    "ButtonTweaksBackgroundColor": "#2D2D2D",
    "ButtonConfigBackgroundColor": "#2D2D2D",
    "ButtonUpdatesBackgroundColor": "#2D2D2D",
    "ButtonWin11ISOBackgroundColor": "#2D2D2D",
    "ButtonInstallForegroundColor": "#F7F7F7",
    "ButtonTweaksForegroundColor": "#F7F7F7",
    "ButtonConfigForegroundColor": "#F7F7F7",
    "ButtonUpdatesForegroundColor": "#F7F7F7",
    "ButtonWin11ISOForegroundColor": "#F7F7F7",
    "ButtonBackgroundColor": "#2D2D2D",
    "ButtonBackgroundPressedColor": "#60CDFF",
    "ButtonBackgroundMouseoverColor": "#383838",
    "ButtonBackgroundSelectedColor": "#404040",
    "ButtonForegroundColor": "#F7F7F7",
    "ToggleButtonOnColor": "#60CDFF",
    "ToggleButtonOffColor": "#666666",
    "ToolTipBackgroundColor": "#2D2D2D",
    "BorderColor": "#404040",
    "BorderOpacity": "0.2"
  }
}
```

Key changes from current:
- Accent: `#EEEE22` (yellow) → `#60CDFF` (Win11 blue)
- Light surface: `#F7F7F7` → `#F0F0F0`, text: `#000000` → `#1A1A1A`
- Dark surface: `#191919` → `#1E1E1E`, cards: `#2F2F2F` → `#2D2D2D`, text: `#F7F7F7` (unchanged)
- Header font: `Consolas, Monaco` → `Segoe UI Variable, Segoe UI`
- Header size: `16` → `18`
- `ButtonCornerRadius`: `2` → `6`

- [ ] **Step 2: Commit**

```bash
git add config/themes.json
git commit -m "refactor(theme): update to Windows 11 color palette and typography"
```

---

### Task 2: Update XAML — Window Background, Corner Radii, Tab Style

**Files:**
- Modify: `xaml/inputXML.xaml`

**Interfaces:**
- Consumes: `themes.json` shared values (`ButtonCornerRadius`, etc.)
- Produces: Updated XAML with transparent window background, bumped corner radii, Win11 tab style

- [ ] **Step 1: Set outer grid background to Transparent (for Mica)**

Line 944: `<Grid Background="{DynamicResource MainBackgroundColor}" ...>`
→ `<Grid Background="Transparent" ...>`

Also set the nav bar grid (line 958) background to Transparent:
`<Grid Grid.Row="1" Background="{DynamicResource MainBackgroundColor}">`
→ `<Grid Grid.Row="1" Background="Transparent">`

- [ ] **Step 2: Update tab ToggleButton style**

Find the ToggleButton style at line ~347. The current `CornerRadius` uses `{DynamicResource ButtonCornerRadius}` which now returns `6`. The inner border pattern should stay but the active indicator changes. Update the checked-state visual to use an accent bottom-border approach instead of solid fill:

Replace the ToggleButton style's checked trigger (around line ~380) to use accent underline:

```xml
<Trigger Property="IsChecked" Value="True">
    <Setter Property="Background" Value="{DynamicResource MainBackgroundColor}"/>
    <Setter TargetName="InnerBorder" Property="BorderBrush" Value="{DynamicResource ToggleButtonOnColor}"/>
    <Setter TargetName="InnerBorder" Property="BorderThickness" Value="0,0,0,3"/>
</Trigger>
```

Also update the normal state border thickness:
```xml
<Setter TargetName="InnerBorder" Property="BorderThickness" Value="0"/>
```

- [ ] **Step 3: Update Button style CornerRadius references**

The default Button style at line ~404 and the `HoverButtonStyle` at line ~189 both reference `{DynamicResource ButtonCornerRadius}` — no code change needed, the value now comes from `themes.json` as `6`.

Update the `AppEntryButtonStyle` (line ~140) — add a CornerRadius setter:
```xml
<Setter Property="CornerRadius" Value="4"/>
```

- [ ] **Step 4: Update search bar and textbox corners**

Find the SearchBarClearButtonStyle (line ~537) — no change needed (it's already a square "X" button).

Find any hardcoded `CornerRadius="2"` or `CornerRadius="5"` in the XAML that should be updated:
- Line 88: `CornerRadius="2"` — in ScrollBar style, keep `5` (already reasonable)
- Line 112: `CornerRadius="2"` — scrollbar repeater button, keep `5`
- Line 323: `CornerRadius="4"` — combobox item, no change
- Line 664: `CornerRadius="10"` — theme preview, no change
- Line 671: `CornerRadius="12.5"` — theme preview, no change
- Line 737: `CornerRadius="8"` — toggle switch border, no change
- Line 834: `CornerRadius="5"` — scrollbar style, update to `4` for Win11 slim look:

```xml
<Setter Property="CornerRadius" Value="4"/>
```

- Line 864, 885, 917: `CornerRadius="5"` — settings popup borders, keep `5`
- Line 1065, 1103, 1169: `CornerRadius="0"` — right-side button group borders, keep `0`
- Line 1259, 1435, 1510: `CornerRadius="5"` — feature/tweak borders, update to `6`:

```xml
CornerRadius="6"
```

- [ ] **Step 5: Commit**

```bash
git add xaml/inputXML.xaml
git commit -m "refactor(xaml): transparent background for Mica, updated corner radii, Win11 tab style"
```

---

### Task 3: Create Enable-Win11Mica.ps1

**Files:**
- Create: `functions/private/Enable-Win11Mica.ps1`

**Interfaces:**
- Consumes: `$sync.Form` (WPF Window object, provided by caller)
- Produces: Function `Enable-Win11Mica` that detects Win11 22H2+ and applies Mica via P/Invoke

- [ ] **Step 1: Write the function**

```powershell
function Enable-Win11Mica {
    <#
    .SYNOPSIS
        Enables Mica material on Windows 11 22H2+ via DwmSetWindowAttribute.
        Silent no-op on Windows 10 or older builds.
    #>
    $minBuild = 22621
    $osVersion = [Environment]::OSVersion.Version

    if ($osVersion.Build -lt $minBuild) {
        Write-Debug "Mica not supported on this OS build ($($osVersion.Build)). Skipping."
        return
    }

    Add-Type -Namespace Win32 -Name DwmApi -MemberDefinition @"
[DllImport("dwmapi.dll", PreserveSig = true)]
public static extern int DwmSetWindowAttribute(IntPtr hwnd, int attr, ref int attrValue, int attrSize);

public const int DWMWA_MICA_ENABLED = 1029;
public const int DWMWA_USE_IMMERSIVE_DARK_MODE = 20;
"@

    $hwnd = (New-Object System.Windows.Interop.WindowInteropHelper $sync.Form).Handle

    $micaValue = 1
    [Win32.DwmApi]::DwmSetWindowAttribute($hwnd, [Win32.DwmApi]::DWMWA_MICA_ENABLED, [ref]$micaValue, 4) | Out-Null

    $isDark = $sync.preferences.theme -eq "Dark"
    $darkModeValue = if ($isDark) { 1 } else { 0 }
    [Win32.DwmApi]::DwmSetWindowAttribute($hwnd, [Win32.DwmApi]::DWMWA_USE_IMMERSIVE_DARK_MODE, [ref]$darkModeValue, 4) | Out-Null

    Write-Debug "Mica enabled for window handle $hwnd (dark=$isDark)"
}
```

- [ ] **Step 2: Commit**

```bash
git add functions/private/Enable-Win11Mica.ps1
git commit -m "feat(mica): add Enable-Win11Mica function with OS detection and P/Invoke"
```

---

### Task 4: Wire Mica into main.ps1

**Files:**
- Modify: `scripts/main.ps1`

**Interfaces:**
- Consumes: `Enable-Win11Mica` (Task 3), `$sync.Form` (existing), `$sync.preferences.theme` (existing)
- Produces: Mica enabled at startup, re-applied on theme change

- [ ] **Step 1: Add Mica call in the Form_Loaded event handler**

In the existing `$sync.Form.Add_Loaded({ ... })` block (line 135), add the Mica call after the interop helper is set up:

Current (line 135-157):
```powershell
$sync.Form.Add_Loaded({
    $interopHelper = New-Object System.Windows.Interop.WindowInteropHelper $sync.Form
    $hwndSource = [System.Windows.Interop.HwndSource]::FromHwnd($interopHelper.Handle)
    $hwndSource.AddHook({
        ...
    })
})
```

Change to:
```powershell
$sync.Form.Add_Loaded({
    Enable-Win11Mica
    $interopHelper = New-Object System.Windows.Interop.WindowInteropHelper $sync.Form
    $hwndSource = [System.Windows.Interop.HwndSource]::FromHwnd($interopHelper.Handle)
    $hwndSource.AddHook({
        ...
    })
})
```

- [ ] **Step 2: Re-apply Mica dark mode on theme change**

After the `Invoke-WinutilThemeChange -theme $sync.preferences.theme` call (line 159) and after `Invoke-WinutilThemeChange` is called from the theme toggle button handler (search for where the theme change is invoked from UI), re-apply the immersive dark mode attribute so the title bar matches.

Find the theme-change invocation in the event handlers. Look for where `Invoke-WinutilThemeChange` is called from button clicks, and add after each:
```powershell
Enable-Win11Mica
```

This is needed because `DWMWA_USE_IMMERSIVE_DARK_MODE` must be re-applied after theme switches since `Invoke-WinutilThemeChange` changes `$sync.preferences.theme`.

- [ ] **Step 3: Commit**

```bash
git add scripts/main.ps1
git commit -m "feat(mica): wire Enable-Win11Mica into startup and theme change"
```

---

### Integration Verification

- [ ] **Step 1: Compile and run**

```powershell
.\Compile.ps1
.\winutil.ps1
```

- [ ] **Step 2: Verify on Win10** — window shows solid `#1E1E1E` / `#FFFFFF` backgrounds, no errors
- [ ] **Step 3: Verify on Win11 22H2+** — Mica material visible behind the window, title bar matches dark/light mode
- [ ] **Step 4: Toggle theme** — light/dark switch updates both the UI colors and the immersive dark mode attribute
