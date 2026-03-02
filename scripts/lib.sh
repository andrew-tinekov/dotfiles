#!/usr/bin/env bash

C_GREEN='\033[0;32m'
C_RED='\033[0;31m'
C_BLUE='\033[0;34m'
C_RESET='\033[0m'

log()     { echo -e "${C_BLUE}→${C_RESET} $*"; }
success() { echo -e "${C_GREEN}✓${C_RESET} $*"; }
error()   { echo -e "${C_RED}✗${C_RESET} $*" >&2; }

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

require_cmd() {
  if ! has_cmd "$1"; then
    error "'$1' is required but not found"
    exit 1
  fi
}

run_as_root() {
  if [ "$EUID" -ne 0 ]; then
    sudo "$@"
  else
    "$@"
  fi
}

sudo_keepalive() {
  [ "$EUID" -eq 0 ] && return
  log "Authenticating..."
  sudo -v
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" 2>/dev/null || exit
  done &
  SUDO_KEEPALIVE_PID=$!
}

sudo_stop() {
  [ "${SUDO_KEEPALIVE_PID:-}" ] && kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
}
