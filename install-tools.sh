#!/usr/bin/env bash
# Some minimal tools to get you started in the VM

set -e
set -u

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR/.env"

export NIXPKGS_ALLOW_UNFREE=1

nix-env -iA \
  nixos.gitFull \
  nixos.curl \
  nixos.neovim \
  nixos.wezterm \
  nixos.tmux \
  nixos.clang \
  nixos.google-chrome \
  nixos.chezmoi

git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
git config --global credential.helper "cache --timeout 72000"

if [ "$DOTFILE_ENABLE" = "true" ]; then
chezmoi init https://github.com/gabyx/chezmoi.git
chezmoi apply
fi

# Install my AstroNvim config
if [ "$NVIM_ASTRO_ENABLE" = "true" ]; then
  git clone --depth 1 --branch nightly https://github.com/AstroNvim/AstroNvim ~/.config/nvim
  git clone "$NVIM_ASTRO_USER_URL" ~/.config/nvim/lua/user
fi

