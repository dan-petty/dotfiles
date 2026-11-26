## Purpose

The title check of a pull request accepts a scope only when this repository declares it. This capability holds which scopes the repository declares for the titles of its pull requests.

## ADDED Requirements

### Requirement: The repository declares each scope that its titles use
`.github/labels.yml` SHALL declare a `scope/<name>` label for each scope that a pull request title of this repository can have, with `ci`, `deps`, `docs` and `spec`. Each `scope/*` label that GitHub holds for the repository MUST be in the file.

#### Scenario: A dependency update passes the title check
- **WHEN** Renovate opens a pull request with the title `chore(deps): ...` and a summary of at most 60 characters.
- **THEN** The check `Semantic PR title` passes.

#### Scenario: A plan with one commit passes the title check
- **WHEN** A pull request into `main` has one commit with the subject `docs(spec): ...`.
- **THEN** The check `Semantic PR title` passes.

#### Scenario: The title check refuses a scope that the file does not declare
- **WHEN** A pull request has a title with a scope that has no `scope/*` label in the file, and is not `main`.
- **THEN** The check `Semantic PR title` fails.
