#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIGS_DIR="$DOTFILES_DIR/configs"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"

source "$SCRIPTS_DIR/lib.sh"

usage() {
  echo "Usage: $0 --mac | --linux [--desktop | --vm | --container]"
  exit 1
}

stow_packages() {
  local skip_pattern="${1:-}"

  require_cmd stow

  for pkg in "$CONFIGS_DIR"/*/; do
    pkg="$(basename "$pkg")"

    if [[ -n "$skip_pattern" && "$pkg" =~ ^($skip_pattern)$ ]]; then
      log "Skipping $pkg"
      continue
    fi

    stow --dir="$CONFIGS_DIR" -R -t ~ "$pkg"
    success "stowed $pkg"
  done
}

setup_ssh_dir() {
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  success "~/.ssh ready"
}

setup_gitconfig_local() {
  local target="$HOME/.gitconfig.local"
  local example="$CONFIGS_DIR/git/.gitconfig.local.example"

  if [[ -f "$target" ]]; then
    success "~/.gitconfig.local already exists, skipping"
    return
  fi

  cp "$example" "$target"
  log "Created ~/.gitconfig.local from example — edit it with your name and email"
}

install_mise_tools() {
  if ! has_cmd mise; then
    log "mise not found, skipping tool installation"
    return
  fi

  log "Installing tools from mise config..."
  eval "$(mise activate bash)"
  mise install -y
  success "mise tools installed"
}

mode="${1:-}"
env="${2:-}"
[[ -z "$mode" ]] && usage

case "$mode" in
  --mac)
    log "Mode: macOS"
    bash "$SCRIPTS_DIR/install_pkgs.sh" mac
    bash "$SCRIPTS_DIR/install_mise.sh" mac
    setup_ssh_dir
    stow_packages
    setup_gitconfig_local
    install_mise_tools
    bash "$SCRIPTS_DIR/set_fish_default.sh"
    ;;
  --linux)
    [[ -z "$env" ]] && usage
    trap sudo_stop EXIT
    sudo_keepalive
    case "$env" in
      --desktop)
        log "Mode: Linux desktop"
        bash "$SCRIPTS_DIR/install_pkgs.sh" linux --build-deps
        bash "$SCRIPTS_DIR/install_mise.sh" linux
        setup_ssh_dir
        stow_packages
        setup_gitconfig_local
        install_mise_tools
        bash "$SCRIPTS_DIR/set_fish_default.sh"
        ;;
      --vm)
        log "Mode: Linux VM (WSL2, Lima)"
        bash "$SCRIPTS_DIR/install_pkgs.sh" linux --build-deps
        bash "$SCRIPTS_DIR/install_mise.sh" linux
        setup_ssh_dir
        stow_packages "ghostty|zsh"
        setup_gitconfig_local
        install_mise_tools
        bash "$SCRIPTS_DIR/set_fish_default.sh"
        ;;
      --container)
        log "Mode: Linux container"
        bash "$SCRIPTS_DIR/install_pkgs.sh" linux
        bash "$SCRIPTS_DIR/install_mise.sh" linux
        stow_packages "ssh|ghostty|zsh|mise"
        setup_gitconfig_local
        install_mise_tools
        ;;
      *)
        error "Unknown environment: $env"
        usage
        ;;
    esac
    ;;
  *)
    error "Unknown flag: $mode"
    usage
    ;;
esac

success "Done!"
