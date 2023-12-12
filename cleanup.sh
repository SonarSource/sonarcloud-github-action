#!/bin/bash

set -e

if [[ -z "${INPUT_PROJECTBASEDIR}" ]]; then
  echo "Error: It seems like you forgot to define the input variable with name PROJECTBASEDIR."
  exit 1
fi

_tmp_file=$(ls "${INPUT_PROJECTBASEDIR}/" | head -1)
PERM=$(stat -c "%u:%g" "${INPUT_PROJECTBASEDIR}/$_tmp_file")

chown -R $PERM "${INPUT_PROJECTBASEDIR}/"

