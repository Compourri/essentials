# Visual Refresh Design — Windows 11 Style

**Date:** 2026-07-07
**Status:** Approved design spec

## Overview

Refresh the WPF/XAML UI of Compourri Software Essentials to match Windows 11 visual language — Mica material, rounded controls, updated color palette, refined typography — while remaining fully functional on Windows 10 via graceful fallback.

## Approach: Hybrid (Mica on Win11, fallback on Win10)

OS detection at startup enables real Mica on Win11 22H2+ (build 22621+); Win10 uses solid theme colors. All other visual updates (rounded corners, palette, typography) apply on both.

## Color Palette

### Light Theme
- Background: `#FFFFFF`
- Surface/cards: `#F0F0F0`
- Border: `#E0E0E0`
- Text primary: `#1A1A1A`
- Text secondary: `#666666`
- Accent: `#60CDFF` (Windows 11 blue)

### Dark Theme
- Background: `#1E1E1E`
- Surface/cards: `#2D2D2D`
- Border: `#404040`
- Text primary: `#F7F7F7`
- Text secondary: `#999999`
- Accent: `#60CDFF`

## Typography
- Body: `Arial` (unchanged)
- Header: `Segoe UI Variable` → `Segoe UI` → fallback (replaces Consolas)
- Header font size: 18pt (up from 16pt)

## Mica Implementation

New function `Enable-Win11Mica` (private):
- Checks `[Environment]::OSVersion.Version` for build >= 22621
- Uses `Add-Type` with C# P/Invoke for `DwmSetWindowAttribute`:
  - `DWMWA_MICA_ENABLED` (1029) — enable Mica
  - `DWMWA_USE_IMMERSIVE_DARK_MODE` (20) — match active theme
- Window background set to `Transparent` in XAML for Mica to show through
- On Win10: skip entirely, use solid theme colors

## Control Styling

- Button CornerRadius: `6` (up from `2`)
- Active tab: accent underline indicator, no solid fill
- Checkboxes: rounded-rect toggle style, accent fill on checked
- Scrollbars: narrower track, rounder thumb (CornerRadius `4`)
- Search bar/textboxes: CornerRadius `4`, thinner border
- Category/app entries: borderless with hover background shift

All corner radii and spacing values remain in `themes.json` (shared section) for easy tweaking.

## XAML Changes

Minimal — structurally unchanged:
- Window background → `Transparent`
- Tab button styles updated for rounded active indicator
- CornerRadius attributes bumped
- Existing grid/layout/tab structure preserved

## Files Changed

| File | Changes |
|---|---|
| `config/themes.json` | New color palette, new shared corner-radius/spacing values |
| `xaml/inputXML.xaml` | Window background Transparent, updated CornerRadius, tab style |
| `functions/private/Enable-Win11Mica.ps1` | **New** — Mica detection + P/Invoke |
| `scripts/main.ps1` | Call Enable-Win11Mica after window handle available |
| `scripts/start.ps1` | Minor — may need adjusted DllImport statements |

## Fallback Behavior

- **Win11 22H2+:** Mica + all visual updates
- **Win11 21H2 / Win10:** Solid theme colors + all visual updates (rounded corners, palette, typography) — no Mica

## Out of Scope

- Layout/structural re-architecture
- New tabs or features
- Animation system (future consideration)
