# Compourri Software Essentials

[![Version](https://img.shields.io/github/v/release/Compourri/essentials?color=%230567ff&label=Latest%20Release&style=for-the-badge)](https://github.com/Compourri/essentials/releases/latest)
![Downloads](https://img.shields.io/github/downloads/Compourri/essentials/winutil.ps1?label=Total%20Downloads&style=for-the-badge)

A curated compilation of Windows system tasks streamline **installs**, debloat with **tweaks**, troubleshoot with **config**, and configure **Windows updates**. Run it fresh on every new Windows install.

![Title Screen](/docs/assets/images/Title-Screen.png)

---

## Quick Start

> **Essentials must be run as Administrator** Because it performs system-wide changes.

Open PowerShell or Terminal as admin, then run:

```ps1
irm https://compourri.co.za/essentials | iex
```

### How to open an admin terminal

- **Start menu:** Right-click Start → *Windows PowerShell (Admin)* or *Terminal (Admin)*
- **Search:** Press the `Windows key`, and type `PowerShell` or `Terminal`, then `Ctrl + Shift + Enter`

---

## Automation / Presets

Apply a predefined configuration without manual selection:

```powershell
& ([ScriptBlock]::Create((irm https://compourri.co.za/essentials))) -Preset Standard
```

| Preset | Description |
|--------|-------------|
| `Standard` | Balanced defaults for most users |
| `Minimal` | Minimal changes to suit every user |
| `Advanced` | Deep tweaks for power users |

To view exactly what each preset does, see:
https://github.com/Compourri/essentials/blob/main/config/preset.json

---

## Resources

- [Official Documentation](https://compourri.github.io/essentials/)

---

## Support

- Leave a ⭐ to show support!

---

## Acknowledgments

This project is a fork of [Chris Titus Tech's Windows Utility](https://github.com/ChrisTitusTech/winutil). Thanks to Chris Titus and the original contributors for building the foundation this project builds on.

