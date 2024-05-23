FROM sonarsource/sonar-scanner-cli:10.0

LABEL version="2.2.0" \
      repository="https://github.com/sonarsource/sonarcloud-github-action" \
      homepage="https://github.com/sonarsource/sonarcloud-github-action" \
      maintainer="SonarSource" \
      com.github.actions.name="SonarCloud Scan" \
      com.github.actions.description="Scan your code with SonarCloud to detect bugs, vulnerabilities and code smells in more than 25 programming languages." \
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

RUN ln -s $SONAR_SCANNER_HOME/bin/sonar-scanner /usr/local/bin/sonar-scanner

# Prepare entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY cleanup.sh /cleanup.sh
RUN chmod +x /cleanup.sh

ENTRYPOINT ["/entrypoint.sh"]
