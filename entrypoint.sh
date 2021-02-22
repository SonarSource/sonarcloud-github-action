#!/bin/bash

set -e

if [[ -f "pom.xml" ]]; then
  echo "Maven project detected. You should run the goal 'org.sonarsource.scanner.maven:sonar' during build rather than using this GitHub Action."
  exit 1
fi

if [[ -f "build.gradle" ]]; then
  echo "Gradle project detected. You should use the SonarQube plugin for Gradle during build rather than using this GitHub Action."
  exit 1
fi

if [[ -z "${SONARCLOUD_URL}" ]]; then
  SONARCLOUD_URL="https://sonarcloud.io"
fi

sonar-scanner -Dsonar.projectBaseDir=${INPUT_PROJECTBASEDIR} -Dsonar.host.url=${SONARCLOUD_URL} ${INPUT_ARGS}
