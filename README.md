<img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/4c449b822779d9f3fca2e0eed36c95b07d623fd9/ng/out/nix.svg" style="margin-left: 20pt" align="right">
<h1>NixOS Installation</h1>

The file [`configuration.nix`](configuration.nix) contains the whole NixOS
configuration and will be used to install the complete system.

The following steps describe how to end up with a QEMU NixOS installation.

Also we want to build a
[NixOS Installer](https://nixos.wiki/wiki/Creating_a_NixOS_live_CD) at then end
out of the working NixOS.

**Note: This setup is by far kick-ass, its more to get you started on an initial
NixOS, which you then can drive further and even install on real hardware.**

![Screenshot](./docs/screenshot.png)

## Prerequisites

Some key insights to ease understanding when working through the below NixOS
install.

- The configuration language `Nix` uses a basic type `String` (e.g. "this is a
  string") and `Path` (`/this/is/a/path`) which are two different things and
  treated differently.

- Check out the manual [NixOs](https://nixos.org/manual/nixos/stable) when
  searching for entry point documentation.

- During modifications consult the two pages:

  - [Package Search](https://search.nixos.org/packages?)
  - [Options Search](https://search.nixos.org/options?)

  for package names and options.

- This NixOS is using the `sway` (Wayland not X11) window manager. To get you
  started when the VM is booted up:

  - `Alt+d` to start a program or
  - press `Alt+Enter` to open `wezterm` terminal with `zsh`.

- The NixOS install is customized with my `.`-files over `chezmoi` which are not
  yet public. [Todo]

## Install NixOS into QEMU Virtual Machine

The documentation [NixOS Manual](https://nixos.org/manual/nixos/stable) provides
useful information when going through these steps:

1. Install `virt-manager` to create a QEMU virtual machine. On Debian systems
   use:

   ```shell
   sudo apt-get install virt-manager
   ```

1. Download the NixOS ISO file from
   [here](https://nixos.org/download#download-nixos).

1. Adjust `.env` file from `.env.tmpl` for your variables.
1. Adjust `.env-os` file from `.env-os.tmpl` for your variables.

### Create VM with `virt-manager` (not recommended)

1. Open `virt-manager` and create a new machine `nixos` by using the
   [downloaded NixOS ISO file](https://channels.nixos.org/nixos-23.05/latest-nixos-gnome-x86_64-linux.iso).
   Create a virtual disk `nixos.qcow2` somewhere.

1. Boot up the virtual machine `nixos` in `virt-manager`. The graphical
   installer should show up. Install NixOS by going through the
   [graphical installer](https://nixos.org/manual/nixos/stable/#sec-installation-graphical).
   Reboot after the install.

### Create VM with Script

1. Create the VM by doing `create-vm.sh` and clicking through the installer. Use
   an LUKS encrypted disk.

### Install Base Tools

1. Start the virtual machine with [`start-vm.sh`](start-vm.sh).

1. Clone this repo (we install git and google-chrome to access passwords)

   ```shell
   NIXPGS_ALLOW_UNFREE=1 nix-env --install --attr nixos.git nixos.google-chrome
   git clone https://github.com/gabyx/nixos-configuration.git
   ```

1. Install some base tools to start working in the fresh NixOS on the
   `/etc/configuration.nix`:

   ```shell
   ./install-tools.sh
   ```

## Connect to VM over SSH

1. Start the virtual machine with [`start-vm.sh`](start-vm.sh).
2. On the host inside a terminal connect over SSH with

   ```shell
   ssh nixos@127.0.0.1 -p 60022
   ```
## Install NixOs on Desktop Hardware

We follow the tutorial from [Pablo Ovelleiro [@pinpox](https://github.com/pinpox)](https://pablo.tools/blog/computers/nixos-encrypted-install).
Boot the NixOS ISO installer of the flashed USB.

### Partioning

Partitioning in NixOS is manual and mostly the same as you would do in Arch or any other "minimal" distribution. You can use gparted if you decided to boot the graphical installer, but I find the process simpler with good-old `gdisk`.

We will be creating two partitions:

- EFI partition (500M)
- Encrypted physical volume for [LVM](https://de.wikipedia.org/wiki/Logical_Volume_Manager) (remaining space)

Furthermore, LVM will be used inside the encrypted physical volume and 
I will be adding (100% + `sqrt(100%)) of my ram as a swap partition (e.g. 64GB = 72GB) if we want proper
hibernation. 
For the thoroughly-paranoid this has the added benefit, that the swap partition will also be encrypted.

Assuming the drive you want to install to is `/dev/sda`, run `gdisk` and create the partitions:
To not make mistakes run the following in the terminal (**replace the disk**):

```shell
MYDISK=/dev/sda
gdisk $MYDISK
```

Then do the following:

  - `o` : Create empty gpt partition table.
  - `n` : Add partition, first sector: default, last sector: +500M, type ef00 EFI (this is `/dev/sda1`).
  - `n` : Add partition, remaining space, type 8e00 Linux LVM (this is  `/dev/sda2`).
  - `w` : Write partition table and exit.

We can now set up the encrypted LUKS partition and open it using cryptsetup

```shell
sudo cryptsetup luksFormat ${MYDISK}2
sudo cryptsetup luksOpen ${MYDISK}2 enc-physical-vol
```
Format the partitions with:

```
sudo mkfs.fat -F 32 ${MYDISK}1
sudo mkfs.btrfs /dev/mapper/env-physical-vol
```

Create subvolumes as follows:

- `root`: The subvolume for `/`, which will be cleared on every boot.
- `home`: The subvolume for `/home`, which should be backed up.
- `nix`: The subvolume for `/nix`, which needs to be persistent but is not worth backing up, as it’s trivial to reconstruct.
- `persist`: The subvolume for `/persist`, containing system state which should be persistent across reboots and possibly backed up.
- `log`: The subvolume for `/var/log`. I’m not so interested in backing up logs but I want them to be preserved across reboots, so I’m dedicating a subvolume to logs rather than using the persist subvolume.

```shell
sudo mount -t btrfs /dev/mapper/enc-physical-vol /mnt
sudo btrfs subvolume create /mnt/root
sudo btrfs subvolume create /mnt/home
sudo btrfs subvolume create /mnt/nix
sudo btrfs subvolume create /mnt/persist
sudo btrfs subvolume create /mnt/log

sudo btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
```

Above we also created an empty snapshot of the root volume 

### Installing NixOS

The partitions just created have to be mounted, e.g. to `/mnt` so we can install NixOS on them.
At this point activating the swap (if you created one) is a good idea. 
The `/boot` partion is mounted in a new folder `/mnt/boot` inside the root partition.

```shell
sudo mount /dev/vg/root /mnt
sudo mkdir /mnt/boot
sudo mount /dev/sda1 /mnt/boot
sudo swapon /dev/vg/swap
```

Now we are going to install this repo's NixOs configuration. For that we clone it
into out future user home folder (you can install is anywhere you want):

```shell
USER=gabyx
NIXPGS_ALLOW_UNFREE=1 nix-env --install --attr nixos.git
sudo mkdir -p /mnt/home/$USER
git clone https://github.com/gabyx/nixos-configuration.git /mnt/home/$USER/.nixos-configuration
```

## Modify NixOS

1. Modify the [`configuration.nix`](configuration.nix) in this repo and use

   ```shell
   ./rebuild-nixos.sh [boot|switch] [--force] vm
   ```

   Use `boot` to build the NixOS (a new generation) and add a new entry in the
   bootloader with the profile `test` and use `switch` to switch live to the new
   generation to it and make it the boot default. Use `--force` to make a new
   generation for the system profile and not `test`.

   **We leave the system initial `/etc/nixos/configuration.nix` untouched.**

   **Note: Make sure you use your disk id in `boot.initrd.luks.devices`.**

## Resizing the _LUKS Encrypted_ Disk (if disk is full)

If `nixos-rebuild` fails due to too little disk space, use the following easy
fix. On the host do the following:

1. Resize the `.qcow2` file with

   ```shell
   source .env-os
   qemu-img resize "$NIXOS_DISK" +40G
   ```

1. Mount the disk with

   ```shell
   source .env-os
   sudo qemu-nbd -c /dev/nbd0 "$NIXOS_DISK"
   ```

1. Run `gparted` with:

   ```shell
   gparted /dev/nbd0
   ```

   and right-click and run `Open Encryption` to decrypt the partition.

1. Use `Partition -> Check` which does an automatic resize to fill the
   partition.

## Running Root GUI Application in Sway

See
[documentation here](https://wiki.archlinux.org/title/Running_GUI_applications_as_root#Using_xhost).
Running root application like `gparted` over `sway` must be done like that:

```shell
sudo -E gparted
```
