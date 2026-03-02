#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"

source "$SCRIPTS_DIR/lib.sh"

require_cmd stow
cd "$DOTFILES_DIR"

always_skip=("scripts" ".git")

for pkg in */; do
  pkg="${pkg%/}"

  skip=false
  for s in "${always_skip[@]}"; do
    [[ "$pkg" == "$s" ]] && skip=true && break
  done
  $skip && continue

  stow -D -t ~ "$pkg"
  success "unstowed $pkg"
done

success "All symlinks unlinked"
