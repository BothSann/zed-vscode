# zed-vscode

One home for Zed and VS Code config, so both editors look and act the same.

**Boss right now: Zed.** When the two disagree, change Zed first, then copy the
change across using the table below. To flip the boss later, read the table the
other way.

## Install

```sh
./install.sh
```

It symlinks each file to the place its editor reads it from. If a real file is
already there, it gets moved to `<name>.pre-link` first.

| File here | Linked to |
|---|---|
| `zed/settings.json`, `keymap.json`, `tasks.json` | `~/.config/zed/` |
| `vscode/settings.json`, `keybindings.json`, `tasks.json` | `~/Library/Application Support/Code/User/` (Default profile) |
| `biome/home.biome.json` | `~/biome.json` |
| `biome/redant.biome.json` | `~/Dev/redant/biome.json` |
| `bin/zed-pint` | `~/.local/bin/zed-pint` |
| `claude/format-after-edit.sh` | `~/.claude/hooks/format-after-edit.sh` |

Secrets aren't stored here. The Intelephense licence key lives in
`~/intelephense/licence.txt`, and both editors read it from there.

## Shared settings

| What | Zed | VS Code | Value |
|---|---|---|---|
| Theme | `theme` | `workbench.colorTheme` | Zedokai Light / Monokai Pro Light |
| Icons | `icon_theme` | `workbench.iconTheme` | Material Icon Theme |
| Font | `buffer_font_family` | `editor.fontFamily` | JetBrainsMono Nerd Font |
| Ligatures | `buffer_font_features.calt` | `editor.fontLigatures` | on |
| Font size | `buffer_font_size` | `editor.fontSize` | 15 |
| Line height | `buffer_line_height: {custom}` | `editor.lineHeight` | 1.5 |
| Terminal font | `terminal.font_family` | `terminal.integrated.fontFamily` | JetBrainsMono Nerd Font Mono |
| Terminal size | `terminal.font_size` | `terminal.integrated.fontSize` | 14 |
| Terminal line height | `terminal.line_height` | `terminal.integrated.lineHeight` | comfortable = 1.618 |
| Shortcuts | `base_keymap` | (native) | VS Code |
| Collapse all folders | `keymap.json` → `project_panel::CollapseAllEntries` | `keybindings.json` → `workbench.files.action.collapseExplorerFolders` | ⌘← in file tree |
| Tab size | `tab_size` (PHP: `languages.PHP.tab_size`) | `editor.tabSize` (PHP: `[php]`) | 2, PHP 4 |
| Ruler | `wrap_guides` | `editor.rulers` | 120 |
| Soft wrap | `soft_wrap: editor_width` | `editor.wordWrap: on` | on (at window edge) |
| Minimap | `minimap.show` | `editor.minimap.enabled` | off |
| Bracket colours | `colorize_brackets` | `editor.bracketPairColorization.enabled` | on |
| Indent guides | `indent_guides.enabled` | `editor.guides.indentation` | on |
| Error text at line end | `diagnostics.inline.enabled` | Error Lens extension (not installed) | off |
| Trim trailing spaces | `remove_trailing_whitespace_on_save` | `files.trimTrailingWhitespace` | on |
| Final newline | `ensure_final_newline_on_save` | `files.insertFinalNewline` | on |
| Autosave | `autosave` | `files.autoSave` | on focus change |
| Format on save | `format_on_save` | `editor.formatOnSave` | on |
| JS/TS/JSON/CSS formatter | `languages.*.formatter` → biome | `[lang].editor.defaultFormatter` → `biomejs.biome` | Biome |
| HTML/MD/YAML formatter | built-in Prettier | `esbenp.prettier-vscode` | Prettier |
| PHP formatter | `languages.PHP.formatter` → `zed-pint` | `[php].editor.defaultFormatter` → `open-southeners.laravel-pint` | Pint (project's own only) |
| Pint whole project | `tasks.json` | `tasks.json` | manual task |

A project's own `.editorconfig` overrides tab size and whitespace in both editors.

## Biome

`~/biome.json` is the fallback style for any project that has no `biome.json`
of its own. Biome looks for a config in the project folder first, then in each
parent folder going up. Rules: 2 spaces, 120 width, double quotes, semicolons,
trailing commas. **Lint and import sorting are off**, so it only formats.

A project's own `biome.json` wins, including whatever lint rules it turns on.

One catch: Biome only reads a project's `.editorconfig` when that project has its own `biome.json`.
So work projects get their own folder-level copy: `biome/redant.biome.json` is linked to
`~/Dev/redant/biome.json`. It's the same style but with 4 spaces, matching those projects'
`.editorconfig`. It sits outside every work repo, so nothing gets committed there.

## Claude Code (AI agent)

Claude Code writes files straight to disk, so its code used to get reformatted the
next time you hit save. `claude/format-after-edit.sh` is a `PostToolUse` hook in
`~/.claude/settings.json`. It runs after every Edit or Write and formats the file
with the same tool the editors use on save:

| Files | Tool |
|---|---|
| JS/TS/JSON/CSS | `biome format --write` (same `biome.json` lookup as the editors) |
| HTML/MD/YAML/SCSS/Vue | `prettier --write` |
| PHP (not Blade) | project's own `vendor/bin/pint`, skipped if the project has none |

The hook itself is in `~/.claude/settings.json`, which isn't in this repository.

## Backups

`backup/` holds the configs from before this setup. It's git-ignored because it
contains the licence key.
