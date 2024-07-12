# How to contribute

We love your input! We want to make contributing to this project as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## Code of Conduct

We take our open source community seriously and hold ourselves and other contributors to high standards of communication. By participating and contributing to this project, you agree to uphold our [Code of Conduct](./CODE_OF_CONDUCT.md).

## Getting started

When contributing to this repository, please first discuss the change you wish to make via issue, email, or any other method with the owners of this repository before making a change.

Contributions are made to this repo via Issues and Pull Requests (PRs). A few general guidelines that cover both:

- Search for existing Issues and PRs before creating your own.
- We work hard to makes sure issues are handled in a timely manner but, depending on the impact, it could take a while to investigate the root cause. A friendly ping in the comment thread to the submitter or a contributor can help draw attention if your issue is blocking.
- Issues should be used to report problems, request a new feature, or to discuss potential changes before a PR is created. When you create a new Issue, a template will be loaded that will guide you through collecting and providing the information we need to investigate.
- If you find an Issue that addresses the problem you're having, please add your own reproduction information to the existing issue rather than creating a new one.
- In general, PRs should:
  - Only fix/add the functionality in question OR address wide-spread whitespace/style issues, not both.
  - Add unit or integration tests for fixed or changed functionality (if a test suite already exists).
  - Address a single concern in the least number of changed lines as possible.
  - Include documentation in the repo or on our docs site.
  - Be accompanied by a complete Pull Request template (loaded automatically when a PR is created).

For changes that address core functionality or would require breaking changes (e.g. a major release), it's best to open an Issue to discuss your proposal first. This is not required but can save time creating and reviewing changes.

In general, we follow the [Github Flow](https://docs.github.com/en/get-started/using-github/github-flow#following-github-flow):

1. Clone the project to your machine (fork the repository to your own Github account only if needed).
1. Create a branch with a succinct but descriptive name referring to an open issue.
1. Commit changes to the branch.
1. If you've added code that should be tested, add tests.
1. Make sure your code lints.
1. Update the README with details of changes.
1. Increase the version numbers in the appropriate files and the README.md to the new version that this
   Pull Request would represent. The versioning scheme we use is [SemVer](http://semver.org/).
1. Open a PR in our repository and follow the PR template so that we can efficiently review the changes.

### Commit Message Guidelines

We have precise rules over how our git commit messages can be formatted. This leads to **more readable messages** that are easy to follow when looking through the **project history** and allows various magic **automation**.

#### Commit Message Format

The commit message should be structured as follows:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

The commit contains the following structural elements, to communicate intent to the consumers of your code:

- **fix**: a commit of the type `fix` patches a bug in your codebase.
- **feat**: a commit of the type `feat` introduces a new feature to the codebase.
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking change. A BREAKING CHANGE can be part of commits of any type.
- types other than `fix` and `feat` are allowed:
  - `build`: Changes that affect the build system or external dependencies (example scopes: ansible, docker, terraform, python)
  - `ci`: Changes to our CI configuration files and scripts (example scopes: Travis, Jenkins, Github)
  - `docs`: Documentation only changes
  - `perf`: A code change that improves performance
  - `refactor`: A code change that neither fixes a bug nor adds a feature
  - `style`: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
  - `test`: Adding missing tests or correcting existing tests
  - `chore`: Lesser tasks; no production code change
  - `revert`: Reverts a previous commit (should include the header or hash of the reverted commit)
- footers should contain any information about **Breaking Changes** and is also the place to reference GitHub issues that this commit **Closes**.

Example:

```
fix: prevent racing of requests

Introduce a request id and a reference to latest request. Dismiss
incoming responses other than from latest request.

Remove timeouts which were used to mitigate the racing issue but are
obsolete now.

Reviewed-by: Z
Refs: #123
```

**References:**

- [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
- [Angular convention](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md)
- [Semantic Commit Messages](https://gist.github.com/joshbuchea/6f47e86d2510bce28f8e7f42ae84c716)

## Any contributions you make will be under the GPL Software License

In short, when you submit code changes, your submissions are understood to be under the same [GPL-3.0-or-later](https://choosealicense.com/licenses/gpl-3.0/) that covers the project. Feel free to contact the maintainers if that's a concern.
