# NixOS Installation

The file [`configuration.nix`](configuration.nix) contains the whole NixOS
configuration and will be used to install the complete system.

We assume to be in Ubuntu. The following steps describe how to end up with a
QEMU NixOS installation.

Also we want to build a
[NixOS Installer](https://nixos.wiki/wiki/Creating_a_NixOS_live_CD) at then end
out of the working NixOS.

## Install NixOS into QEMU Virtual Machine

The documentation [NixOS Manual](https://nixos.org/manual/nixos/stable) provides
useful information when going through these steps:

1. Install `virt-manager` to create a QEMU virtual machine.

   ```shell
   sudo apt-get install virt-manager
   ```

1. Adjust `.env` file from `.env.tmpl` for your variables.
1. Adjust `.env-os` file from `.env-os.tmpl` for your variables.

## Create VM with `virt-manager`

1. Open `virt-manager` and create a new machine `nixos` by using the
   [downloaded NixOS ISO file](https://channels.nixos.org/nixos-23.05/latest-nixos-gnome-x86_64-linux.iso).
   Create a virtual disk `nixos.qcow2` somewhere.

1. Boot up the virtual machine `nixos` in `virt-manager`. The graphical
   installer should show up. Install NixOS by going through the
   [graphical installer](https://nixos.org/manual/nixos/stable/#sec-installation-graphical).
   Reboot after the install.

### Create with Script

1. Create the VM by doing `create-vm.sh` and clicking through the installer. Use
   an LUKS encrypted disk.

1. Start the virtual machine with [`start-vm.sh`](start-vm.sh).

### Install Base Tools

1. Clone this repo

   ```shell
   export NIXPGS_ALLOW_UNFREE=1
   nix-env --install --attr nixos.git nixos.google-chrome

   git clone https://github.com/gabyx/nixos-configuration.git
   ```

1. Install base tools to start working on the `/etc/configuration.nix`:

   ```shell
   ./install-tools.sh
   ```

### Install User Configs

I use `chezmoi` to install my user config on the machine. Do this

```shell
nix-env -iA nixos.chezmoi
chezmoi init https://github.com/gabyx/chezmoi.git
chezmoi apply
```

## Modify NixOS

1. Modify the [`configuration.nix`](configuration.nix) in this repo and use

   ```shell
   nixos-rebuild -I nixos-config=~/nixos-configuration/configuration.nix switch -p test
   ```

   to make a new entry in the bootloader with the new system `test`.

## Resizing the _LUKS Encrypted_ Disk (if disk is full)

1. On the host: Resize the `.qcow2` file with

   ```shell
   source .env-os
   qemu-img resize "$NIXOS_DISK" +10G
   ```

1. Start the installer with `create-vm.sh` again.
1. Once in the installer, run `gparted` and `Decrypt` the partition (right click
   on it) and enter the password.
1. Use `Partition -> Check` which does an automatic resize to fill the
   partition.
