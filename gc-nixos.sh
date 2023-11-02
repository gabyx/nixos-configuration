#!/usr/bin/env bash
set -e
set -u

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR/.env"

nix-env --delete-generations --profile /nix/var/nix/profiles/system-profiles/test "*"
