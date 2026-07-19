# Design Spec: Essentials C# Rewrite

## Overview

Rewrite Compourri Software Essentials from a PowerShell script into a compiled .NET 9/C# WPF application using Wpf.Ui for modern controls. The goal is a single self-contained executable with a polished UI, type-safe config, and better performance.

## Scope (Initial Release)

Core features only — App Management and System Tweaks. Additional features (DNS, Windows Features, Updates, ISO, Repairs) will be added in future iterations.

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Language | C# |
| Runtime | .NET 9 |
| UI Framework | WPF + Wpf.Ui |
| MVVM | CommunityToolkit.Mvvm |
| JSON | System.Text.Json |
| Publish | Self-contained, trimmed, single-file |

## Project Structure

```
essentials/
├── src/
│   └── Essentials/
│       ├── Essentials.csproj
│       ├── App.xaml
│       ├── Models/
│       │   ├── AppInfo.cs
│       │   ├── TweakInfo.cs
│       │   └── TweakPreset.cs
│       ├── ViewModels/
│       │   ├── MainViewModel.cs
│       │   ├── AppsViewModel.cs
│       │   └── TweaksViewModel.cs
│       ├── Views/
│       │   ├── MainWindow.xaml
│       │   ├── AppsPage.xaml
│       │   └── TweaksPage.xaml
│       ├── Services/
│       │   ├── PackageService.cs
│       │   ├── TweakService.cs
│       │   └── ConfigService.cs
│       └── Configs/
│           ├── applications.json
│           └── tweaks.json
├── Essentials.sln
└── README.md
```

## Architecture

### MVVM Pattern

- **Models**: Plain C# classes with properties. No UI logic.
- **ViewModels**: Expose `ObservableCollection<T>` for lists, `RelayCommand` for actions. Inherit from `ObservableObject` (CommunityToolkit.Mvvm).
- **Views**: XAML pages bound to ViewModels via `{Binding}`. No business logic in code-behind.
- **Services**: Stateless helpers for package operations, registry manipulation, config loading. Injected into ViewModels via constructor.

### Data Flow

```
JSON Configs → ConfigService → Models → ViewModels → Views (Wpf.Ui)
```

### NuGet Packages

- `Wpf.Ui` — NavigationView, CardControl, ToggleSwitch, InfoBar, ProgressRing
- `CommunityToolkit.Mvvm` — ObservableObject, RelayCommand, ObservableProperty
- `System.Text.Json` — JSON deserialization

## Models

### AppInfo

```csharp
public class AppInfo
{
    public string Name { get; set; }
    public string Category { get; set; }
    public string WingetId { get; set; }
    public string ChocoId { get; set; }
    public string Description { get; set; }
    public string Link { get; set; }
    public bool IsFoss { get; set; }
}
```

### TweakInfo

```csharp
public class TweakInfo
{
    public string Name { get; set; }
    public string Description { get; set; }
    public string Category { get; set; }
    public RegistryAction[] RegistryActions { get; set; }
    public string InvokeScript { get; set; }    // Inline PowerShell script
    public string UndoScript { get; set; }      // Inline PowerShell script
    public bool DefaultEnabled { get; set; }
}

public class RegistryAction
{
    public string Path { get; set; }    // e.g., "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion"
    public string Name { get; set; }    // Value name
    public object Value { get; set; }   // Value data
    public string Type { get; set; }    // "DWord", "String", "QWord", etc.
}
```

**Registry path format:** Full path including hive (e.g., `HKLM\SOFTWARE\...` or `HKCU\SOFTWARE\...`). The TweakService parses the hive prefix to select the correct `RegistryKey`.

**Script format:** Inline PowerShell scripts as strings. Executed via `pwsh -Command` or `powershell -Command` on the target machine.

### InstalledApp

```csharp
public class InstalledApp
{
    public string Name { get; set; }
    public string Id { get; set; }        // Package manager ID (winget/choco)
    public string Version { get; set; }
    public string Source { get; set; }    // "winget" or "choco"
}
```

### TweakPreset

```csharp
public class TweakPreset
{
    public string Name { get; set; }
    public string[] TweakNames { get; set; }
}
```

## Services

### ConfigService

- Loads `applications.json` and `tweaks.json` from embedded resources at startup
- Deserializes into `List<AppInfo>` and `List<TweakInfo>`
- Provides filtered/sorted access to ViewModels
- JSON format compatible with existing Essentials configs

### PackageService

```csharp
public class PackageService
{
    public bool IsWingetAvailable();
    public bool IsChocoAvailable();
    public Task<List<InstalledApp>> GetInstalledAppsAsync();
    public Task InstallAppAsync(AppInfo app, IProgress<string> progress);
    public Task UninstallAppAsync(AppInfo app, IProgress<string> progress);
    public Task UpgradeAppAsync(AppInfo app, IProgress<string> progress);
}
```

- Wraps `winget` and `choco` CLI commands via `System.Diagnostics.Process`
- Runs operations on background threads via `Task.Run`
- Reports progress via `IProgress<string>`
- Checks admin privileges before operations that require elevation

### TweakService

```csharp
public class TweakService
{
    public Task ApplyTweakAsync(TweakInfo tweak, IProgress<string> progress);
    public Task UndoTweakAsync(TweakInfo tweak, IProgress<string> progress);
    public Task ApplyPresetAsync(TweakPreset preset);
    public bool IsTweakApplied(TweakInfo tweak);
}
```

- Registry tweaks: `Microsoft.Win32.Registry` API using `RegistryAction.Path` to select hive and open key, then set value
- Script tweaks: `System.Diagnostics.Process` running `pwsh -Command "<inline script>"`
- Each tweak is atomic — failures reported but don't block other tweaks
- Tracks applied tweaks via `HashSet<string>` of tweak names for undo functionality

## UI Design

### MainWindow Layout

```
┌─────────────────────────────────────────────────┐
│  ◀  ▶  │  Compourri Essentials              ─ □ X│
├─────────┼───────────────────────────────────────┤
│         │                                       │
│  📦 Apps│   [Current Page Content]              │
│  ⚙ Tweaks│                                     │
│         │                                       │
│         │                                       │
│         ├───────────────────────────────────────┤
│         │  Status: Ready | Winget: v1.2.3       │
└─────────┴───────────────────────────────────────┘
```

### Wpf.Ui Controls Used

- `NavigationPage` — sidebar with icon + label for each tab
- `CardControl` — app cards with toggle buttons
- `ToggleSwitch` — tweak toggles
- `TextBox` with search icon — search/filter
- `ProgressRing` — during operations
- `InfoBar` — success/error notifications

### Theme

Wpf.Ui's built-in dark/light theme via `AppearanceManager`. Auto-detects system theme on startup.

### AppsPage

- Searchable grid of ~296 apps
- Category filter sidebar (Utilities, Multimedia, Games, etc.)
- FOSS-only toggle
- Each app card: name, category, description, FOSS badge, Install/Uninstall/Upgrade button
- Progress indicator during operations

### TweaksPage

- Categorized toggle switches
- Preset buttons: "Standard" / "Minimal"
- "Restore All Changes" button
- Status indicators showing what's currently applied

## Build & Distribution

### Publish Command

```bash
dotnet publish src/Essentials/Essentials.csproj \
  -r win-x64 \
  --self-contained true \
  /p:PublishTrimmed=true \
  /p:PublishSingleFile=true \
  -c Release \
  -o dist/
```

### Output

Single `Essentials.exe` (~15-25MB trimmed)

### Distribution

- GitHub Releases with tagged versions
- Users download `Essentials.exe` directly
- No PowerShell launcher
- Admin elevation via `app.manifest`

### CI/CD

GitHub Actions workflow: build on push/tag, upload artifacts to releases.

## Upstream Relationship

This is a reference-only fork. The C# app will use Essentials' config files as a starting point but will not maintain sync with ChrisTitusTech/winutil. Config updates are manual.

## Future Features (Out of Scope for Initial Release)

- DNS Configuration
- Windows Features Management
- Windows Updates Management
- Windows 11 ISO Tool
- System Repairs
- Autologin, SSH, Power Plan utilities
