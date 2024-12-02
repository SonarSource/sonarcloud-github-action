#!/bin/bash

set -eo pipefail

declare -a args=()

if [[ -z "${SONAR_TOKEN}" ]]; then
  echo "Set the SONAR_TOKEN env variable."
  exit 1
fi

if [[ -f "${INPUT_PROJECTBASEDIR%/}/pom.xml" ]]; then
  echo "WARNING! Maven project detected. Sonar recommends running the 'org.sonarsource.scanner.maven:sonar-maven-plugin:sonar' goal during the build process instead of using this GitHub Action
  to get more accurate results."
fi

if [[ -f "${INPUT_PROJECTBASEDIR%/}/build.gradle" || -f "${INPUT_PROJECTBASEDIR%/}/build.gradle.kts" ]]; then
  echo "WARNING! Gradle project detected. Sonar recommends using the SonarQube plugin for Gradle during the build process instead of using this GitHub Action
  to get more accurate results."
fi

if [[ ${SONARCLOUD_URL} ]]; then
  args+=("-Dsonar.scanner.sonarcloudUrl=${SONARCLOUD_URL}")
fi

if [[ "$RUNNER_DEBUG" == '1' ]]; then
  args+=("--debug")
fi

unset JAVA_HOME

args+=("-Dsonar.projectBaseDir=${INPUT_PROJECTBASEDIR}")

sonar-scanner "${args[@]}" ${INPUT_ARGS}




# cleanup
set -e

if [ ! -d "${INPUT_PROJECTBASEDIR}/.scannerwork" ]; then
    echo ".scannerwork directory not found; nothing to clean up."
    exit
fi

_tmp_file=$(ls "${INPUT_PROJECTBASEDIR}/" | head -1)
PERM=$(stat -c "%u:%g" "${INPUT_PROJECTBASEDIR}/$_tmp_file")

chown -R "$PERM" "${INPUT_PROJECTBASEDIR}/.scannerwork/"
