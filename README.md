# Analyze your code for free with SonarCloud

Using this GitHub Action, scan your code with [SonarCloud](https://www.sonarsource.com/products/sonarcloud/?utm_medium=referral&utm_source=github&utm_campaign=sc-product&utm_content=signup-sonarcloud-listing-x-x&utm_term=ww-psp-x) to detects bugs, vulnerabilities and code smells in 26+ programming languages!
In case you want to analyze C and C++ code: rely on our [SonarCloud Scan for C and C++](https://github.com/marketplace/actions/sonarcloud-scan-for-c-and-c) and look at [our sample C and C++ project](https://github.com/sonarsource-cfamily-examples?q=gh-actions-sc&type=all&language=&sort=)

<img src="./images/SonarCloud-72px.png">

SonarCloud is the leading product for Continuous Code Quality & Code Security online, totally free for open-source projects. It supports all major programming languages, including Java, JavaScript, TypeScript, C#, [C and C++](https://github.com/marketplace/actions/sonarcloud-scan-for-c-and-c), and many more. If your code is closed source, SonarCloud also offers a free, no-commitment 14-day trial to run private analyses. Start your free trial here: [SonarCloud Sign up](https://www.sonarsource.com/products/sonarcloud/signup/?utm_medium=referral&utm_source=github&utm_campaign=sc-signup&utm_content=signup-sonarcloud-listing-x-x&utm_term=ww-psp-x). With SonarCloud, you also get IDE Support with [SonarLint](https://www.sonarsource.com/products/sonarlint/?utm_medium=referral&utm_source=github&utm_campaign=sc-signup&utm_content=signup-sonarcloud-listing-x-x&utm_term=ww-psp-x) integration to find code issues on the fly. SonarCloud rules and analysis settings synchronize to [SonarLint](https://www.sonarsource.com/products/sonarlint/?utm_medium=referral&utm_source=github&utm_campaign=sc-signup&utm_content=signup-sonarcloud-listing-x-x&utm_term=ww-psp-x), aligning teams around a single standard of [Clean Code](https://www.sonarsource.com/solutions/clean-code/).

## Requirements

* Create your account on SonarCloud. Sign up for free now if it's not already the case! [SonarCloud Sign up](https://www.sonarsource.com/products/sonarcloud/signup/?utm_medium=referral&utm_source=github&utm_campaign=sc-signup&utm_content=signup-sonarcloud-listing-x-x&utm_term=ww-psp-x)
* The repository to analyze is set up on SonarCloud. [Set it up](https://sonarcloud.io/projects/create) in just one click.

## Usage

Project metadata, including the location of the sources to be analyzed, must be declared in the file `sonar-project.properties` in the base directory:

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
    - uses: actions/checkout@v3
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
https://docs.sonarcloud.io/advanced-setup/analysis-parameters

See also example configurations at:
https://github.com/sonarsource/sonarcloud-github-action-samples/

### Secrets

- `SONAR_TOKEN` – **Required** this is the token used to authenticate access to SonarCloud. You can generate a token on your [Security page in SonarCloud](https://sonarcloud.io/account/security/). You can set the `SONAR_TOKEN` environment variable in the "Secrets" settings page of your repository.
- *`GITHUB_TOKEN` – Provided by Github (see [Authenticating with the GITHUB_TOKEN](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/authenticating-with-the-github_token)).*

## Example of pull request analysis

<img src="./images/SonarCloud-analysis-in-Checks.png">

Want to see more examples of SonarCloud in action? You can [explore current Open Source projects in SonarCloud](https://sonarcloud.io/explore/projects?sort=-analysis_date?utm_medium=referral&utm_source=github&utm_campaign=sc-signup&utm_content=signup-sonarcloud-listing-x-x&utm_term=ww-psp-x) that are using the Clean as You Code methodology.

## Do not use this GitHub action if you are in the following situations

* Your code is built with Maven: run 'org.sonarsource.scanner.maven:sonar' during the build
* Your code is built with Gradle: use the SonarQube plugin for Gradle during the build
* You want to analyze a .NET solution: Follow our interactive tutorial for GitHub Actions after importing your project directly into SonarCloud
* You want to analyze C and C++ code: rely on our [SonarCloud Scan for C and C++](https://github.com/marketplace/actions/sonarcloud-scan-for-c-and-c) and look at [our sample C and C++ project](https://github.com/sonarsource-cfamily-examples?q=gh-actions-sc&type=all&language=&sort=)

## Have questions or feedback?

To provide feedback (requesting a feature or reporting a bug) please post on the [SonarSource Community Forum](https://community.sonarsource.com/) with the tag `sonarcloud`.

## License

The Dockerfile and associated scripts and documentation in this project are released under the LGPLv3 License.

Container images built with this project include third-party materials.
