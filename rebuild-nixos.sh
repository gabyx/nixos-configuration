
#!/usr/bin/env bash
set -e
set -u

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR/.env"

sudo nixos-rebuild -I nixos-config=./configs/nixos/configuration.nix \
  switch -p test
