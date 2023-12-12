#!/bin/bash

set -e

_tmp_file=$(ls "${INPUT_PROJECTBASEDIR}/" | head -1)
PERM=$(stat -c "%u:%g" "${INPUT_PROJECTBASEDIR}/$_tmp_file")

chown -R $PERM "${INPUT_PROJECTBASEDIR}/.scannerwork/"

