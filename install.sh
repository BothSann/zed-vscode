#!/bin/sh
# Links the config files in this folder to where each editor reads them.
# Safe to re-run. An existing real file is moved aside to <name>.pre-link first.
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
VSC="$HOME/Library/Application Support/Code/User"

link() { # link <source in this folder> <target path>
  if [ -e "$2" ] && [ ! -L "$2" ]; then mv "$2" "$2.pre-link"; fi
  ln -sfn "$HERE/$1" "$2"; echo "linked $2 -> $1"
}

mkdir -p "$HOME/.config/zed" "$VSC" "$HOME/.local/bin" "$HOME/.claude/hooks"
link zed/settings.json     "$HOME/.config/zed/settings.json"
link zed/keymap.json       "$HOME/.config/zed/keymap.json"
link zed/tasks.json        "$HOME/.config/zed/tasks.json"
link vscode/settings.json  "$VSC/settings.json"
link vscode/keybindings.json "$VSC/keybindings.json"
link vscode/tasks.json     "$VSC/tasks.json"
link biome/home.biome.json      "$HOME/biome.json"
# Work projects (~/Dev/redant) use 4 spaces, matching their .editorconfig
[ -d "$HOME/Dev/redant" ] && link biome/redant.biome.json "$HOME/Dev/redant/biome.json"
link bin/zed-pint          "$HOME/.local/bin/zed-pint"
link claude/format-after-edit.sh "$HOME/.claude/hooks/format-after-edit.sh"

if [ ! -s "$HOME/intelephense/licence.txt" ]; then
  echo "NOTE: put your Intelephense key in ~/intelephense/licence.txt (both editors read it)"
fi
