
#!/usr/bin/env bash
#
# Copied from /var/log/libvirt/qemu/nixos.log
# This is the command virt-manager used to start the VM.
#

set -e
set -u

DIR=$(cd "$(dirname "$0")" && pwd)

nix-env -iA nixos.gitFull nixos.curl nixos.neovim nixos.wezterm nixos.tmux nixos.clang
