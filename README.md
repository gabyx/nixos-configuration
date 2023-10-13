# NixOS Installation

The file [`configuration.nix`](configuration.nix) contains the whole NixOS
configuration and will be used to install the complete system.

We assume to be in Ubuntu. The following steps describe how to end up with a
QEMU NixOS installation.

Also we want to build a
[NixOS Installer](https://nixos.wiki/wiki/Creating_a_NixOS_live_CD) at then end
out of the working NixOS.

## Install Base NixOS into QEMU Virtual Machine

The documentation [NixOS Manual](https://nixos.org/manual/nixos/stable) provides
useful information when going through these steps:

1. Install `virt-manager` to create a QEMU virtual machine.

   ```shell
   sudo apt-get install virt-manager
   ```

2. Open `virt-manager` and create a new machine `nixos` by using the
   [downloaded NixOS ISO file](https://channels.nixos.org/nixos-23.05/latest-nixos-gnome-x86_64-linux.iso).
   Create a virtual disk `nixos.qcow2` somewhere.

3. Boot up the virtual machine `nixos` in `virt-manager`. The graphical
   installer should show up. Install NixOS by going through the
   [graphical installer](https://nixos.org/manual/nixos/stable/#sec-installation-graphical).
   Reboot after the install.

4. Start the virtual machine with [`start-vm.sh`](start-vm.sh) by adjusting the
   `disk=` file.

5. Install base tools to start working on the `/etc/configuration.nix`:

   ```shell
   nix-env -i git curl neovim wezterm tmux
   ```

6. Clone this repo

   ```shell
   git clone https://github.com/gabyx/nixos-configuration.git
   ```

## Modify the Installation
