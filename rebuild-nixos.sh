#!/usr/bin/env bash
set -e
set -u

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR/.env"

force="false"
[ "${1:-}" = "--force" ] && force="true" && shift

config="vm"
[ -n "${1:-}" ] && config="-$1" && shift

export NIXPGKS_ALLOW_INSECURE=1

if [ "$force" = "true" ]; then
  echo "Rebuild & switch current system (default boot entry)."
	sudo nixos-rebuild -I "nixos-config=./configuration$config.nix" \
		"$@" switch 
else
  echo "Rebuild & switch system with boot entry name 'test'."
	sudo nixos-rebuild -I "nixos-config=./configuration$config.nix" \
		"$@" switch -p test
fi
