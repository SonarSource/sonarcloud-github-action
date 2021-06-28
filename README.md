# Scan your code with SonarCloud

Using this GitHub Action, scan your code with [SonarCloud](https://sonarcloud.io/) to detects bugs, vulnerabilities and code smells in more than 20 programming languages!

<img src="./images/SonarCloud-72px.png">

SonarCloud is the leading product for Continuous Code Quality & Code Security online, totally free for open-source projects. It supports all major programming languages, including Java, JavaScript, TypeScript, C#, C/C++ and many more. If your code is closed source, SonarCloud also offers a paid plan to run private analyses.

## Requirements

* Have an account on SonarCloud. [Sign up for free now](https://sonarcloud.io/sessions/init/github) if it's not already the case!
* The repository to analyze is set up on SonarCloud. [Set it up](https://sonarcloud.io/projects/create) in just one click.

## Usage

Project metadata, including the location to the sources to be analyzed, must be declared in the file `sonar-project.properties` in the base directory:

```properties
sonar.organization=<replace with your SonarCloud organization key>
sonar.projectKey=<replace with the key generated when setting up the project on SonarCloud>

# relative paths to source directories. More details and properties are described
# in https://sonarcloud.io/documentation/project-administration/narrowing-the-focus/ 
sonar.sources=.
```

The workflow, usually declared in `.github/workflows/build.yml`, looks like:

```yaml
on:
  # Trigger analysis when pushing in master or pull requests, and when creating
  # a pull request. 
  push:
    branches:
      - master
  pull_request:
      types: [opened, synchronize, reopened]
name: Main Workflow
jobs:
  sonarcloud:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
      with:
        # Disabling shallow clone is recommended for improving relevancy of reporting
        fetch-depth: 0
    - name: SonarCloud Scan
      uses: sonarsource/sonarcloud-github-action@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```

You can change the analysis base directory by using the optional input `projectBaseDir` like this:

```yaml
uses: sonarsource/sonarcloud-github-action@master
with:
  projectBaseDir: my-custom-directory
```

In case you need to add additional analysis parameters, you can use the `args` option:

```yaml
- name: Analyze with SonarCloud
  uses: sonarsource/sonarcloud-github-action@master
  with:
    projectBaseDir: my-custom-directory
    args: >
      -Dsonar.organization=my-organization
      -Dsonar.projectKey=my-projectkey
      -Dsonar.python.coverage.reportPaths=coverage.xml
      -Dsonar.sources=lib/
      -Dsonar.test.exclusions=tests/**
      -Dsonar.tests=tests/
      -Dsonar.verbose=true
```

More information about possible analysis parameters is found in the documentation at:
https://sonarcloud.io/documentation/analysis/analysis-parameters/

### Secrets

- `SONAR_TOKEN` – **Required** this is the token used to authenticate access to SonarCloud. You can generate a token on your [Security page in SonarCloud](https://sonarcloud.io/account/security/). You can set the `SONAR_TOKEN` environment variable in the "Secrets" settings page of your repository.
- *`GITHUB_TOKEN` – Provided by Github (see [Authenticating with the GITHUB_TOKEN](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/authenticating-with-the-github_token)).*

## Example of pull request analysis

<img src="./images/SonarCloud-analysis-in-Checks.png">

## Do not use this GitHub action if you are in the following situations

* Your code is built with Maven: run 'org.sonarsource.scanner.maven:sonar' during the build
* Your code is built with Gradle: use the SonarQube plugin for Gradle during the build
* You want to analyze a .NET solution: use the [SonarCloud Azure DevOps Extension](https://marketplace.visualstudio.com/items?itemName=SonarSource.sonarcloud) to analyze your code on SonarCloud with Azure Pipelines
* You want to analyze C/C++ code: rely on our [Travis-CI extension](https://docs.travis-ci.com/user/sonarcloud/) and look at [our sample C/C++ project](https://github.com/SonarSource/sq-com_example_c-sqscanner-travis)
* You want to analyze C/C++/Objective-C code on `windows-latest`: see [this guide](https://community.sonarsource.com/t/sonarcloud-with-msbuild-build-wrapper-on-github-actions/35607) contributed on our community forum

## Have question or feedback?

To provide feedback (requesting a feature or reporting a bug) please post on the [SonarSource Community Forum](https://community.sonarsource.com/) with the tag `sonarcloud`.

## License

The Dockerfile and associated scripts and documentation in this project are released under the LGPLv3 License.

Container images built with this project include third party materials.

[![Build Status](https://travis-ci.com/SonarSource/sonarcloud-github-action.svg?branch=master)](https://travis-ci.com/SonarSource/sonarcloud-github-action)
