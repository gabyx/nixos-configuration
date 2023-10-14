
#!/usr/bin/env bash
#
# Copied from /var/log/libvirt/qemu/nixos.log
# This is the command virt-manager used to start the VM.
#

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
  nixos.google-chrome

git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

# Install my AstroNvim config
if [ "$NVIM_ASTRO_ENABLE" = "true" ]; then
  git clone --depth 1 --branch nightly https://github.com/AstroNvim/AstroNvim ~/.config/nvim
  git clone "$NVIM_ASTRO_USER_URL" ~/.config/nvim/lua/user
fi

