# Scan your code with SonarQube Cloud [![QA](https://github.com/SonarSource/sonarcloud-github-action/actions/workflows/qa.yml/badge.svg)](https://github.com/SonarSource/sonarcloud-github-action/actions/workflows/qa.yml)

> [!WARNING]
> This action is deprecated and will be removed in a future release. 
> Please use the `sonarqube-scan-action` action instead. 
> The `sonarqube-scan-action` is a drop-in replacement for this action, you can find it [here](https://github.com/marketplace/actions/official-sonarqube-scan).

This SonarSource project, available as a GitHub Action, scans your projects with SonarQube [Cloud](https://www.sonarsource.com/products/sonarcloud/).

![Logo](./images/SQ_Logo_Cloud_Dark_Backgrounds.png#gh-dark-mode-only)
![Logo](./images/SQ_Logo_Cloud_Light_Backgrounds.png#gh-light-mode-only)

SonarQube [Cloud](https://www.sonarsource.com/products/sonarcloud/) (formerly SonarCloud) is a widely used static analysis solution for continuous code quality and security inspection.

It helps developers detect coding issues in 30+ languages, frameworks, and IaC platforms, including Java, JavaScript, TypeScript, C#, Python, C, C++, and [many more](https://www.sonarsource.com/knowledge/languages/).

The solution also provides fix recommendations leveraging AI with Sonar's AI CodeFix capability.

## Requirements

* Create your account on SonarQube Cloud. [Sign up for free](https://www.sonarsource.com/products/sonarcloud/signup/?utm_medium=referral&utm_source=github&utm_campaign=sc-signup&utm_content=signup-sonarcloud-listing-x-x&utm_term=ww-psp-x) now if it's not already the case!
* The repository to analyze is set up on SonarQube Cloud. [Set it up](https://sonarcloud.io/projects/create) in just one click.

## Usage

Project metadata, including the location of the sources to be analyzed, must be declared in the file `sonar-project.properties` in the base directory:

```properties
sonar.organization=<replace with your SonarQube Cloud organization key>
sonar.projectKey=<replace with the key generated when setting up the project on SonarQube Cloud>

# relative paths to source directories. More details and properties are described
# at https://docs.sonarsource.com/sonarqube-cloud/advanced-setup/analysis-scope/
sonar.sources=.
```

The workflow, usually declared under `.github/workflows`, looks like:

```yaml
on:
  # Trigger analysis when pushing to your main branches, and when creating a pull request.
  push:
    branches:
      - main
      - master
      - develop
      - 'releases/**'
  pull_request:
      types: [opened, synchronize, reopened]

name: Main Workflow
jobs:
  sonarqube:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
      with:
        # Disabling shallow clones is recommended for improving the relevancy of reporting
        fetch-depth: 0
    - name: SonarQube Scan
      uses: sonarsource/sonarcloud-github-action@<action version> # Ex: v4.0.0, See the latest version at https://github.com/marketplace/actions/sonarcloud-scan
      env:
        SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```

## Action parameters

You can change the analysis base directory by using the optional input `projectBaseDir` like this:

```yaml
- uses: sonarsource/sonarcloud-github-action@<action version>
  with:
    projectBaseDir: app/src
```

In case you need to specify the version of the Sonar Scanner, you can use the `scannerVersion` option:

```yaml
- uses: sonarsource/sonarcloud-github-action@<action version>
  with:
    scannerVersion: 6.2.0.4584
```

In case you need to add additional analysis parameters, and you do not wish to set them in the `sonar-project.properties` file, you can use the `args` option:

```yaml
- uses: sonarsource/sonarcloud-github-action@<action version>
  with:
    projectBaseDir: app/src
    args: >
      -Dsonar.organization=my-organization
      -Dsonar.projectKey=my-projectkey
      -Dsonar.python.coverage.reportPaths=coverage.xml
      -Dsonar.sources=lib/
      -Dsonar.tests=tests/
      -Dsonar.test.exclusions=tests/**
      -Dsonar.verbose=true
```

You can also specify the URL where to retrieve the SonarScanner CLI from.
The specified URL overrides the default address: `https://binaries.sonarsource.com/Distribution/sonar-scanner-cli`.
This can be useful when the runner executing the action is self-hosted and has regulated or no access to the Internet:

```yaml
- uses: sonarsource/sonarcloud-github-action@<action version>
  with:
    scannerBinariesUrl: https://my.custom.binaries.url.com/Distribution/sonar-scanner-cli/
```

More information about possible analysis parameters can be found in the [Analysis parameters page](https://docs.sonarsource.com/sonarqube-cloud/advanced-setup/analysis-parameters/) of the SonarQube Cloud documentation.

### Environment variables

- `SONAR_TOKEN` – **Required** this is the token used to authenticate access to SonarQube. You can read more about security tokens in the [documentation](https://docs.sonarsource.com/sonarqube-cloud/managing-your-account/managing-tokens/). You can set the `SONAR_TOKEN` environment variable in the "Secrets" settings page of your repository, or you can add them at the level of your GitHub organization (recommended).
- *`GITHUB_TOKEN` – Provided by Github (see [Authenticating with the GITHUB_TOKEN](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/authenticating-with-the-github_token)).*
- `SONAR_ROOT_CERT` – Holds an additional certificate (in PEM format) that is used to validate the certificate of a secured proxy to SonarQube Cloud. You can set the `SONAR_ROOT_CERT` environment variable in the "Secrets" settings page of your repository, or you can add them at the level of your GitHub organization (recommended).

Here is an example of how you can pass a certificate (in PEM format) to the Scanner truststore:

```yaml
- uses: sonarsource/sonarcloud-github-action@<action version>
  env:
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
    SONAR_ROOT_CERT: ${{ secrets.SONAR_ROOT_CERT }}
```

If your source code file names contain special characters that are not covered by the locale range of `en_US.UTF-8`, you can configure your desired locale like this:

```yaml
- uses: sonarsource/sonarcloud-github-action@<action version>
  env:
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
    LC_ALL: "ru_RU.UTF-8"
```

## Alternatives for Java, .NET, and C/C++ projects

This GitHub Action will not work for all technologies. If you are in one of the following situations, you should use the following alternatives:

* Your code is built with Maven. Read the documentation about our [SonarScanner for Maven](https://docs.sonarsource.com/sonarqube-cloud/advanced-setup/ci-based-analysis/sonarscanner-for-maven/).
* Your code is built with Gradle. Read the documentation about our [SonarScanner for Gradle](https://docs.sonarsource.com/sonarqube-cloud/advanced-setup/ci-based-analysis/sonarscanner-for-gradle/).
* You want to analyze a .NET solution. Read the documentation about our [SonarScanner for .NET](https://docs.sonarsource.com/sonarqube-cloud/advanced-setup/ci-based-analysis/sonarscanner-for-dotnet/introduction/).
* You want to analyze C or C++ code. Starting from SonarQube 10.6, this GitHub Action will scan C and C++ out of the box. If you want to have better control over the scan configuration/setup, you can switch to the [SonarQube Cloud Scan for C and C++](https://github.com/marketplace/actions/sonarcloud-scan-for-c-and-c) GitHub Action - look at [our sample C and C++ project](https://github.com/sonarsource-cfamily-examples?q=gh-actions-sc&type=all&language=&sort=).

## Have questions or feedback?

To provide feedback (requesting a feature or reporting a bug) please post on the [SonarSource Community Forum](https://community.sonarsource.com/tags/c/help/sc/9/github-actions).

## License

Container images built with this project include third-party materials.
