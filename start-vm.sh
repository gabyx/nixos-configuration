#!/usr/bin/env bash
#
# Copied from /var/log/libvirt/qemu/nixos.log
# This is the command virt-manager used to start the VM.
#

set -e
set -u

DIR=$(cd "$(dirname "$0")" && pwd)

. "$DIR/.env"

/usr/bin/qemu-system-x86_64 \
-enable-kvm \
-m 8G \
-smp 8 \
-hda "$NIXOS_DISK" \
-netdev user,id=net0,net=192.168.0.0/24,dhcpstart=192.168.0.9 \
-device virtio-net-pci,netdev=net0 \
-vga qxl \
-device AC97 \
"$@"

