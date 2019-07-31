FROM openjdk:11-jre-slim

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

ENV SONAR_SCANNER_HOME=${SONAR_SCANNER_HOME} \
    SONAR_SCANNER_VERSION=3.3.0.1492 \
    NODEJS_HOME=${NODEJS_HOME} \
    NODEJS_VERSION=v8.12.0

ENV PATH=${PATH}:${SONAR_SCANNER_HOME}/bin:${NODEJS_HOME}/bin

WORKDIR /opt

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget git jq unzip tar xz-utils \
    && rm -rf /var/lib/apt/lists/*

RUN wget -U "sonarcloud-github-action" -q -O sonar-scanner-cli.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip \
    && unzip sonar-scanner-cli.zip \
    && rm sonar-scanner-cli.zip \
    && mv sonar-scanner-${SONAR_SCANNER_VERSION} ${SONAR_SCANNER_HOME}

RUN wget -q -O nodejs.tar.xz https://nodejs.org/dist/${NODEJS_VERSION}/node-${NODEJS_VERSION}-linux-x64.tar.xz \
    && tar -Jxf nodejs.tar.xz \
    && mv node-${NODEJS_VERSION}-linux-x64 ${NODEJS_HOME}

RUN npm install -g typescript

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
