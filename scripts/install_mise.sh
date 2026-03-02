#!/usr/bin/env bash
set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPTS_DIR/lib.sh"

mode="${1:-}"

if has_cmd mise; then
  success "mise already installed ($(mise --version))"
  exit 0
fi

case "$mode" in
  mac)
    require_cmd brew
    log "Installing mise via brew..."
    brew install mise
    success "mise installed"
    ;;

  linux)
    log "Installing mise via apt..."
    run_as_root apt-get update -qq
    run_as_root install -dm 755 /etc/apt/keyrings
    curl -fSs https://mise.jdx.dev/gpg-key.pub | run_as_root tee /etc/apt/keyrings/mise-archive-keyring.asc > /dev/null
    echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.asc] https://mise.jdx.dev/deb stable main" \
      | run_as_root tee /etc/apt/sources.list.d/mise.list
    run_as_root apt-get update -qq
    run_as_root apt-get install -y mise
    success "mise installed"
    ;;

  *)
    echo "Usage: $0 [mac | linux]"
    exit 1
    ;;
esac
