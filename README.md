# Dotfiles

## Architecture

- Configs are managed with [GNU Stow](https://www.gnu.org/software/stow/) — each tool has its own folder that mirrors `~/`
- `bootstrap.sh` installs all dependencies, links configs via stow, and installs mise tools (neovim, go, node, python, ruby, rust)
- Sensitive or machine-specific config (`.gitconfig.local`, `.ssh/config.local`) stays local and out of the repo

## What's included

| Package     | Config location           |
|-------------|---------------------------|
| fish        | `~/.config/fish/`         |
| ghostty     | `~/.config/ghostty/`      |
| git         | `~/.gitconfig`            |
| mise        | `~/.config/mise/`         |
| mise_neovim | `~/.config/mise/conf.d/`  |
| nvim        | `~/.config/nvim/`         |
| ssh         | `~/.ssh/config`           |
| tmux        | `~/.tmux.conf`            |
| zsh         | `~/.zshrc`, `~/.zprofile` |

## Installation

**Mac**

Xcode CLI tools and Homebrew are installed automatically if missing.

```sh
./bootstrap.sh --mac
```

**Linux desktop**

Full setup, stows everything.

```sh
./bootstrap.sh --linux --desktop
```

**Linux VM** (WSL2, Lima)

Skips `ghostty` and `zsh` to avoid conflicts with VM-managed shell config.

```sh
./bootstrap.sh --linux --vm
```

**Container**

Minimal setup — skips `ssh`, `ghostty`, `zsh`, and full mise config. Only neovim is installed via mise.

```sh
./bootstrap.sh --linux --container
```

## Post-install

`bootstrap.sh` creates `~/.gitconfig.local` from the template — add your name and email:

```sh
nvim ~/.gitconfig.local
```

## Uninstall

Remove all symlinks created by stow:

```sh
./stow_remove.sh
```
