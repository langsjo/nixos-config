#!/usr/bin/env bash

set -e

nix build .#optionDocs
cat result > OPTIONS.md
rm result
