# Branding Guide

This document lists all Compourri branding locations that must be maintained after merging upstream changes from ChrisTitusTech/winutil.

## Quick Fix

Run the post-merge branding script after each upstream merge:

```powershell
.\scripts\Apply-Branding.ps1
```

## Branding Locations

### scripts/start.ps1
| Line | Original (Upstream) | Compourri |
|------|---------------------|-----------|
| 3 | `Author: Chris Titus @ChrisTitusTech` | `Author: George van der Westhuizen @Compourri` |
| 6 | `GitHub: https://github.com/ChrisTitusTech/winutil` | `GitHub: https://github.com/Compourri` |
| 38 | `"WinUtil is unable to run..."` | `"Essentials is unable to run..."` |
| 43 | `"Winutil needs to be run as Administrator..."` | `"Essentials needs to be run as Administrator..."` |
| 102 | `winutil_$dateTime.log` | `essentials_$dateTime.log` |
| 105 | `"WinUtil (Admin)"` | `"Software Essentials (Admin)"` |

### scripts/main.ps1
| Line | Original (Upstream) | Compourri |
|------|---------------------|-----------|
| 124 | `"Quitting winutil..."` | `"Quitting Essentials..."` |
| 323 | `"WinUtil lost focus"` | `"Software Essentials lost focus"` |
| 489-495 | CTT author info block | Compourri author info block |

### xaml/inputXML.xaml
| Line | Original (Upstream) | Compourri |
|------|---------------------|-----------|
| 15 | `Title="WinUtil"` | `Title="Software Essentials"` |

### functions/private/Show-CustomDialog.ps1
| Line | Original (Upstream) | Compourri |
|------|---------------------|-----------|
| 180 | `"WinUtil"` | `"Compourri Software Essentials"` |

### functions/public/Show-CompourriLogo.ps1
| Line | Original (Upstream) | Compourri |
|------|---------------------|-----------|
| 29 | `=== WinUtil ===` | `=== Compourri Software Essentials ===` |

### functions/public/Invoke-WPFButton.ps1
| Line | Original (Upstream) | Compourri |
|------|---------------------|-----------|
| 16 | `"Chris Titus Tech's Windows Utility"` | `"Compourri Software Essentials"` |

### config/tweaks.json
| Line | Original (Upstream) | Compourri |
|------|---------------------|-----------|
| 845 | `"WinUtil modifications"` | `"Software Essentials modifications"` |
| 864 | `"created by WinUtil"` | `"created by Software Essentials"` |

### MessageBox Titles (functions/public/*.ps1)
All `MessageBox` calls with title `"Winutil"` should be changed to `"Essentials"`:
- Invoke-WPFFeatureInstall.ps1
- Invoke-WPFInstall.ps1
- Invoke-WPFGetInstalled.ps1
- Invoke-WPFInstallUpgrade.ps1
- Invoke-WPFtweaksbutton.ps1
- Invoke-WPFundoall.ps1
- Invoke-WPFUnInstall.ps1

## Fork-Only Files

These files only exist in our fork. The branding script auto-deletes them if upstream re-introduces them:
- `docs/static/CNAME`
- `.github/CODE_OF_CONDUCT.md`
- `.github/CONTRIBUTING.md`

Additional fork-only files that won't be overwritten:
- `LICENSE` — GPL-3.0 with MIT notice for original portions
- `NOTICE` — attribution for original MIT-licensed work
- `docs/` — all content, branding, logo, screenshots
- `docs/hugo.toml`, `docs/i18n/en.yaml`
- `config/preset.json`

### docs/hugo.toml
| Line | Original (Upstream) | Compourri |
|------|---------------------|-----------|
| 3 | `title = "WinUtil Documentation"` | `title = "Essentials Documentation"` |
| 80 | `url = "https://github.com/christitustech/winutil"` | `url = "https://github.com/Compourri/essentials"` |
| 128 | `url = "https://github.com/ChrisTitusTech/winutil"` | `url = "https://github.com/Compourri/essentials"` |

### docs/i18n/en.yaml
| Line | Original (Upstream) | Compourri |
|------|---------------------|-----------|
| 1 | `href='https://christitus.com'>Chris Titus Tech` | `href='https://compourri.co.za'>Compourri` |

### docs/content/ (all .md files)
After upstream merges, run branding script or manually replace:
- User-facing "WinUtil"/"Winutil" → "Essentials" (not function names in code blocks)
- GitHub URLs → `https://github.com/Compourri/essentials`
- Shields.io badge URLs → `Compourri/essentials`
- Launch commands → `irm "https://compourri.co.za/essentials" | iex`
- `winutil.christitus.com` → `compourri.github.io/essentials`
