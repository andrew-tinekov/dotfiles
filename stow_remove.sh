#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIGS_DIR="$DOTFILES_DIR/configs"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"

source "$SCRIPTS_DIR/lib.sh"

require_cmd stow

for pkg in "$CONFIGS_DIR"/*/; do
  pkg="$(basename "$pkg")"
  stow --dir="$CONFIGS_DIR" -D -t ~ "$pkg"
  success "unlinked $pkg"
done

success "All symlinks unlinked"
