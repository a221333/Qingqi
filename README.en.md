# Qingqi (轻启)

[简体中文](README.md) | **English**

**A 326 KB native Windows launcher built for Chinese Pinyin search, with non-intrusive middle-click batch rename for OneCommander.**

![Version](https://img.shields.io/badge/version-1.1.0-blue)
![Platform](https://img.shields.io/badge/platform-Windows-0078D6)
![Runtime](https://img.shields.io/badge/.NET%20Framework-4.8-512BD4)
![Size](https://img.shields.io/badge/size-326%20KB-brightgreen)
![Tests](https://img.shields.io/badge/tests-58%2F58%20passed-success)

Qingqi is a fast, minimal, and reliable desktop productivity utility for Windows. Press `Alt + Space` to launch apps, folders, and web searches with full Chinese Pinyin and English matching. Starting in v1.1, selecting multiple files in OneCommander and clicking the middle mouse button opens OneCommander's native **File Automator** batch rename preview in a single click.

---

## Highlights

- **Ultra-Lightweight, Zero-Dependency Portable Binary**
  `Qingqi.exe` is just **326 KB** (334,336 bytes), built natively on Windows `.NET Framework 4.8` and WPF. No extra runtime installation required, high-DPI aware, and fully portable—copy to any folder and run.
- **Fast Chinese & English Launcher (`Alt + Space`)**
  Ships with an embedded Pinyin table supporting **Chinese substrings, full Pinyin, Pinyin initials, ordered fuzzy initials, and mixed Latin/Han queries**. Results are ranked smartly (**Exact Alias > Full Name > Usage Frequency**), with support for direct URLs / naked domains, encoded website search templates, custom launch arguments, pinned/recent/hidden items, and unsafe URL scheme rejection.
- **OneCommander Middle-Click Batch Rename (New in v1.1)**
  In OneCommander's classic single-pane layout, select 2 or more files and press the middle mouse button inside the file list to immediately open the native **File Automator** preview window.
- **Strict, Non-Intrusive Safeguards**
  Triggers only when all conditions are met (**classic single pane + ≥ 2 selected files + cursor inside the file list + no modifier keys**). Single selections, dual-pane mode, drags, floating overlays, and all other applications keep their original middle-click behavior untouched. **Never reads or modifies the clipboard, and never auto-clicks "Process".**
- **Transactional Config Safety & Verified Delivery**
  Configuration files use atomic UTF-8 writes with rollback on failure and backup recovery for corrupted files. Built with `warnaserror`, backed by **58/58 passing automated tests**, real-machine interaction verification, and published SHA-256 checksums.

---

## Quick Start

### 1. Run Qingqi

1. Download the latest release archive from [Releases](https://github.com/a221333/Qingqi/releases) and extract it (keep `Qingqi.exe` and `Qingqi.exe.config` in the same folder for portable use).
2. Run `Qingqi.exe` with **standard user privileges** (match OneCommander's privilege level).
3. Qingqi stays in the system tray. Right-click the tray icon at any time to toggle **OneCommander middle-click batch rename** or manage entries and settings.

### 2. Daily Launcher & Search

- Press **`Alt + Space`** to summon the search bar and type Chinese characters, full Pinyin, initials, or English keywords to match local apps, folders, and custom shortcuts.
- Open URLs or naked domains directly, or invoke parameterized web search templates and exact aliases.
- Pin, hide, or customize launch arguments; automatic directory scanning merges cleanly with manual entries.

### 3. OneCommander Middle-Click Batch Rename

1. In OneCommander's **Classic / Single** layout, select **at least 2 files**.
2. Release modifier keys (`Ctrl`, `Shift`, etc.), keep the pointer inside the file list, and click the **middle mouse button** (scroll wheel press).
3. Configure your rename rules in the native **File Automator** window, verify the preview, and click **Process** (opening the preview never modifies files).

> **Example**: Pick `Simple rename`, set the naming pattern to `Report_##`, enable converting `#` to sequence numbers starting at `1`, and leave the forced extension field blank to preserve original extensions—previewing `Report_01.txt`, `Report_02.txt`, etc.

---

## Trigger & Pass-Through Boundaries

| Scenario | Behavior | Notes |
|---|---|---|
| Classic single pane + ≥ 2 selected files + no modifiers + middle click in file list | **Opens File Automator preview** | Preview only; never auto-executes rename |
| 0 or 1 selected file | Passes middle click through | Preserves OneCommander default behavior |
| Dual-pane layout | Passes middle click through | Avoids active-pane ambiguity on global Process |
| Column layout | Not yet supported (pass-through) | Requires exactly one visible file list |
| Modifier keys held (`Ctrl`/`Shift`) or dragging | Passes through / cancels | Prevents accidental combo triggers |
| Other apps or overlay window above file list | Passes middle click through | Verifies both foreground and hit-test windows |
| Feature disabled via tray menu | Passes middle click through | Instant toggle; `Alt + Space` remains active |

---

## Environment & Checksums

| Item | Details |
|---|---|
| Executable | `Qingqi.exe` (v`1.1.0.0`, `334,336` bytes / ~`326 KB`) |
| SHA-256 | `decf6bf5dc1f524dbed3d9a9f79eb03fe0abf407e1a43bdf0cc2c722cb23f4d1` |
| Requirements | Windows + `.NET Framework 4.8` (built into Windows 10/11) |
| Verified OneCommander | `3.108.0.0` (Classic single-pane layout) |
| Automated Tests | **58 / 58 passed** (Core 37 + WPF Transactions 11 + Middle-Click Guard 10) |

For full test logs, static metadata inspection, and real-machine verification notes, see [verification.md](verification.md) and the `verification/` directory.

---

<details>
<summary>Original Local Deployment & Rollback Notes</summary>

- In the original local deployment, Start Menu shortcuts and startup entries point to `Qingqi.exe` in this directory; copying the executable elsewhere runs it portably without modifying existing shortcuts.
- On the original machine, running `RestorePrevious.cmd` restores the previous Start Menu shortcut, startup entry, and executable using `previous-entrypoints.json` and `previous-entrypoints-20261109-162345/` while keeping existing user settings.

</details>

---

## Acknowledgments & Notices

- Pinyin data is derived from [mozillazg/pinyin-data](https://github.com/mozillazg/pinyin-data) (MIT License). See [THIRD-PARTY-NOTICES.txt](THIRD-PARTY-NOTICES.txt).
