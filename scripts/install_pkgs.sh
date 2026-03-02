#!/usr/bin/env bash
set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPTS_DIR/lib.sh"

ensure_xcode_tools() {
  if xcode-select -p &>/dev/null; then
    success "Xcode Command Line Tools already installed"
    return
  fi
  log "Installing Xcode Command Line Tools..."
  xcode-select --install
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
  success "Xcode Command Line Tools installed"
}

ensure_brew() {
  if has_cmd brew; then
    success "Homebrew already installed"
    return
  fi
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  success "Homebrew installed"
}

install_linux_base() {
  run_as_root apt-get update -qq
  run_as_root apt-get install -y curl git ripgrep stow tmux unzip fish
}

install_ruby_build_deps() {
  run_as_root apt-get install -y \
    build-essential autoconf libssl-dev libyaml-dev \
    zlib1g-dev libffi-dev libgmp-dev
}

mode="${1:-}"
extras="${2:-}"

case "$mode" in
  mac)
    ensure_xcode_tools
    ensure_brew
    log "Installing packages via brew..."
    brew install ripgrep stow tmux fish
    success "brew packages installed"
    ;;

  linux)
    log "Installing base dependencies via apt..."
    install_linux_base
    if [[ "$extras" == "--build-deps" ]]; then
      install_ruby_build_deps
    fi
    success "apt packages installed"
    ;;

  *)
    echo "Usage: $0 [mac | linux [--build-deps]]"
    exit 1
    ;;
esac
