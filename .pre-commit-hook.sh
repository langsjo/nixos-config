#!/usr/bin/env bash

if ! nix fmt -- --fail-on-change ; then
    echo "Files were formatted, add and commit again" >&2
    exit 1
fi
