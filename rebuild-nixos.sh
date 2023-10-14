
#!/usr/bin/env bash
set -e
set -u

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR/.env"

export NIXPGKS_ALLOW_INSECURE=1

sudo nixos-rebuild -I nixos-config=./configuration.nix \
  switch -p test
