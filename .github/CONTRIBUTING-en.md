# Contributing Guidelines

Welcome to **Estação-Trabalho-CMC** project!

Thank you for your interest in contributing! By participating, you are helping to improve and maintain this project, making it more useful for everyone.

This document provides guidelines to ensure that your contributions are well received and efficiently incorporated into the project.

## How to Contribute

We welcome various types of contributions, including:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Improving documentation
- Becoming a maintainer

When contributing to this repository, please first discuss the change you wish to make with the owners of this repository before making a change.

## Reporting Issues

If you find a bug or have a suggestion for improvement, follow these steps when opening an _issue_:

1. **Check if the issue already exists** to avoid duplicates.
2. **Provide a clear and descriptive title**.
3. **Explain the current problem and how your suggestion can improve it**.
4. **Include environment details** (OS version, software version, etc.).
5. **Describe the steps to reproduce the issue**.
6. **Include logs or screenshots** if relevant.

Please try to stick to the provided issue template and avoid removing or leaving any sections blank.

A few general guidelines:

- We work hard to makes sure issues are handled in a timely manner but, depending on the impact, it could take a while to investigate the root cause. A friendly ping in the comment thread to the submitter or a contributor can help draw attention if your issue is blocking.
- Issues should be used to report problems, request a new feature, or to discuss potential changes before a PR is created. When you create a new Issue, a template will be loaded that will guide you through collecting and providing the information we need to investigate.
- If you find an Issue that addresses the problem you're having, please add your own reproduction information to the existing issue rather than creating a new one.

For changes that address core functionality or would require breaking changes (e.g. a major release), it's best to open an Issue to discuss your proposal first. This is not required but can save time creating and reviewing changes.

## Code Patterns

- Follow the style conventions established by the project (ESLint, PEP8, etc.).
- Use consistent indentation.
- Name variables and functions clearly and without excessive abbreviations.
- Write explanatory comments when necessary.

## Commit Messages

We have precise rules over how our git commit messages can be formatted. This leads to **more readable messages** that are easy to follow when looking through the **project history** and allows various magic **automation**.

We use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) enforced by [commitlint](https://github.com/conventional-changelog/commitlint) and [commitzen](https://github.com/commitizen/cz-cli). Enable it in your repository and write clear, descriptive commit messages, in the format: `feat: add feature x` or `fix: fix bug y`.

For examples and more on this topic, see also:

- [How to Write a Perfect Git Commit Message](https://medium.com/@bruno-bernardes-tech/how-to-write-a-perfect-git-commit-message-b1e7a1537d51)
- [Angular convention](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md)
- [Semantic Commit Messages](https://gist.github.com/joshbuchea/6f47e86d2510bce28f8e7f42ae84c716)
- [How to Write Better Git Commit Messages](https://www.freecodecamp.org/news/how-to-write-better-git-commit-messages/)

## Submitting Pull Requests (PRs)

In general, we use [Github Flow](https://docs.github.com/en/get-started/using-github/github-flow#following-github-flow). Please, follow these steps when submitting a PR:

1. **Clone the project** to your machine (fork the repository to your own Github account only if needed).
2. **Create a new branch** referring to an open issue (`feat/feature-name` or `fix/fix-name`).
3. **Follow the commit best practices** (see the [Commit Messages](#commit-messages) section).
4. **Ensure that your code follows project standards** (see the [Code Patterns](#code-patterns) section).
5. **Add tests** if you've added code that should be tested.
6. **Run the tests before submitting the PR**.
7. **Make sure your code lints**.
8. **Add documentation** if your contribution requires it.
9. **Increase the version numbers** in the appropriate files (including `README.md` and `CHANGELOG.md`) to the new version that this
   Pull Request would represent. The versioning scheme we use are [SemVer](http://semver.org/) and [Keep a Changelog](http://keepachangelog.com/).
10. **Clearly describe what your PR does** and refer to related issues.

In general, PRs should:

- Only fix/add the functionality in question OR address wide-spread whitespace/style issues, not both.
- Add unit or integration tests for fixed or changed functionality (if a test suite already exists).
- Address a single concern in the least number of changed lines as possible.
- Include documentation in the repo or on our docs site.
- Be accompanied by a complete Pull Request template (loaded automatically when a PR is created).

## Review and Approval

All contributions will undergo review before being merged into the main code. The review will take into account:

- Clarity and quality of the code.
- Adherence to project guidelines.
- Impact of the change on the system.

If adjustments are needed, reviewers will make suggestions and request changes before final approval.

## Code of Conduct

We take our open source community seriously and hold ourselves and other contributors to high standards of communication. By participating and contributing to this project, you agree to uphold our [Code of Conduct](./CODE_OF_CONDUCT.md).

## Any contributions you make will be under the GPL Software License

In short, when you submit code changes, your submissions are understood to be under the same [GPL-3.0-or-later](https://choosealicense.com/licenses/gpl-3.0/) that covers the project. Feel free to contact the maintainers if that's a concern.

## Communication Channels

To ask questions or discuss ideas, use the following channels:

- Issues on GitHub for problems and suggestions.
- Pull Requests to discuss code changes.
- [E-mail](mailto:suporte@cmc.pr.gov.br) for other subjects.

---

:heart: We love your input! Thank you for making this project better!
