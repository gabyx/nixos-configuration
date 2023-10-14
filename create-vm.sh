#!/usr/bin/env bash
set -e
set -u

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR/.env-os"

if [ -f "$NIXOS_DISK" ]; then
	echo "Disk '$NIXOS_DISK' already existing! Delete it if you want to reinstall NixOS." >&2
else
	qemu-img create -f qcow2 "$NIXOS_DISK" 12G
fi

"$DIR/start-vm.sh" \
	-boot d \
	-cdrom "$NIXOS_ISO"
