#!/bin/bash

set -e

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

if [[ -z "${SONARCLOUD_URL}" ]]; then
  SONARCLOUD_URL="https://sonarcloud.io"
fi

debug_flag=''
if [[ "$RUNNER_DEBUG" == '1' ]]; then
  debug_flag=' --debug '
fi

unset JAVA_HOME
sonar-scanner $debug_flag -Dsonar.projectBaseDir=${INPUT_PROJECTBASEDIR} -Dsonar.host.url=${SONARCLOUD_URL} ${INPUT_ARGS}
