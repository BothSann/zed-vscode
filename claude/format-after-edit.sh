#!/bin/sh
# Claude Code PostToolUse hook: format a file right after Claude edits it, with the
# same tools and configs Zed and VS Code use on save. Then cmd+s has nothing left to change.
#   JS/TS/JSON/CSS            -> biome   (project biome.json, else ~/Dev/redant/biome.json, else ~/biome.json)
#   HTML/MD/YAML/SCSS/Vue     -> prettier
#   PHP                       -> the project's own vendor/bin/pint (skipped if the project has none)
# Never blocks Claude: always exits 0.

f="$(jq -r '.tool_response.filePath // .tool_input.file_path // empty')"
[ -n "$f" ] && [ -f "$f" ] || exit 0
case "$f" in */node_modules/*|*/vendor/*|*/.git/*|*.blade.php) exit 0 ;; esac

dir="$(dirname "$f")"

case "$f" in
  *.js|*.jsx|*.mjs|*.cjs|*.ts|*.tsx|*.mts|*.cts|*.json|*.jsonc|*.css)
    # Biome finds its config from the working directory upward, like the editors do
    (cd "$dir" && /opt/homebrew/bin/biome format --write "$f") >/dev/null 2>&1
    ;;
  *.html|*.md|*.yml|*.yaml|*.scss|*.vue)
    (cd "$dir" && /opt/homebrew/bin/prettier --write "$f") >/dev/null 2>&1
    ;;
  *.php)
    root="$dir"
    while [ "$root" != "/" ] && [ ! -x "$root/vendor/bin/pint" ]; do root="$(dirname "$root")"; done
    [ -x "$root/vendor/bin/pint" ] && (cd "$root" && ./vendor/bin/pint --quiet "$f") >/dev/null 2>&1
    ;;
esac
exit 0
