---
title: Automation
weight: 7
prev: /userguide/updates/
next: /userguide/win11creator/
---

Use Automation to run Software Essentials from an exported configuration file.

Software Essentials supports predefined presets that apply common configurations automatically:

- `Standard`
- `Minimal`
- `Advanced`

Example:

```powershell
& ([ScriptBlock]::Create((irm "https://compourri.co.za/essentials"))) -Preset Standard
```

To view exactly what each preset does, see:
https://github.com/Compourri/essentials/blob/main/config/preset.json

To create your own config file:

1. Open Software Essentials.
2. Click the gear icon in the top-right corner.
3. Choose **Export**.
4. Save the exported JSON file.

Once you have exported a config, launch Software Essentials with it using this command:
```powershell
& ([ScriptBlock]::Create((irm "https://compourri.co.za/essentials"))) -Config "C:\Path\To\Config.json"
```

This is useful for:

- Applying the same Software Essentials configuration across multiple Windows 11 PCs
- Reusing a known-good baseline after reinstalling Windows
- Standardizing deployments for labs, workstations, or personal setups

> [!NOTE]
> Run the command in an elevated PowerShell session so Software Essentials can apply system-level changes.
