FROM sonarsource/sonar-scanner-cli:4.3

LABEL version="0.0.1"
LABEL repository="https://github.com/sonarsource/sonarcloud-github-action"
LABEL homepage="https://github.com/sonarsource/sonarcloud-github-action"
LABEL maintainer="SonarSource"
LABEL "com.github.actions.name"="SonarCloud Scan"
LABEL "com.github.actions.description"="Scan your code with SonarCloud to detect bugs, vulnerabilities and code smells in more than 25 programming languages."
LABEL "com.github.actions.icon"="check"
LABEL "com.github.actions.color"="green"

ARG SONAR_SCANNER_HOME=/opt/sonar-scanner
ARG NODEJS_HOME=/opt/nodejs

ENV PATH=${PATH}:${SONAR_SCANNER_HOME}/bin:${NODEJS_HOME}/bin

WORKDIR /opt

# https://help.github.com/en/actions/creating-actions/dockerfile-support-for-github-actions#user
USER root

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
