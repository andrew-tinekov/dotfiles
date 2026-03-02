#!/usr/bin/env bash
set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPTS_DIR/lib.sh"

require_cmd fish

FISH_PATH="$(command -v fish)"

if [[ "$SHELL" == "$FISH_PATH" ]]; then
  success "fish is already your default shell"
  exit 0
fi

if ! grep -qF "$FISH_PATH" /etc/shells; then
  log "Adding $FISH_PATH to /etc/shells..."
  echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
fi

sudo chsh -s "$FISH_PATH"
success "Default shell set to fish — takes effect on next login"
