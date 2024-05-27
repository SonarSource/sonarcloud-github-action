FROM public.ecr.aws/l3k7d6g6/sonarsource/sonar-scanner-cli:10.0

LABEL version="2.2.0" \
      repository="https://github.com/bucketplace/sonarcloud-github-action" \
      homepage="https://github.com/bucketplace/sonarcloud-github-action" \
      maintainer="Eng/Core" \
      com.github.actions.name="SonarCloud Scan" \
      com.github.actions.description="This repository is forked from SonarSource/sonarcloud-github-action to avoid DockerHub throttle limit." \
      com.github.actions.icon="check" \
      com.github.actions.color="green"

ARG SONAR_SCANNER_HOME=/opt/sonar-scanner
ARG NODEJS_HOME=/opt/nodejs

ENV PATH=${PATH}:${SONAR_SCANNER_HOME}/bin:${NODEJS_HOME}/bin

# set up local envs in order to allow for special chars (non-asci) in filenames
ENV LC_ALL="C.UTF-8"

WORKDIR /opt

# GitHub actions should be run under ROOT
# https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners/about-github-hosted-runners#docker-container-filesystem
USER 0

# Prepare entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY cleanup.sh /cleanup.sh
RUN chmod +x /cleanup.sh

ENTRYPOINT ["/entrypoint.sh"]
