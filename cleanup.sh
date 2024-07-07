#!/bin/bash

set -e

if [ ! -d "${INPUT_PROJECTBASEDIR}/.scannerwork" ]; then
    echo ".scannerwork directory not found; nothing to clean up."
    exit
fi

_tmp_file=$(ls "${INPUT_PROJECTBASEDIR}/" | head -1)
PERM=$(stat -c "%u:%g" "${INPUT_PROJECTBASEDIR}/$_tmp_file")

chown -R "$PERM" "${INPUT_PROJECTBASEDIR}/.scannerwork/"

