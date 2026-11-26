# Proposal: #15

## Why

The pull request title check refuses valid scopes (#15). The reusable workflow `pr-title.yml` of dan-petty/infra takes the allowed scopes from the `scope/*` labels of `.github/labels.yml`, plus `main`. The file declares no `scope/*` label, so the check refuses `chore(deps)` and every other scope.

- `.github/renovate.json` sets the prefixes `chore:` and `fix:` in place of the `chore(deps):` and `fix(deps):` of the shared preset, because the repository declared no scope.

## What Changes

- `.github/labels.yml` declares the `scope/*` labels of this repository, in gray (`DCDCD6`), each with a description.
- The base scopes `ci`, `deps`, `docs` and `spec`.
- Each `scope/*` label that GitHub holds.
- The areas of the files: `git`, `install`, `starship`, `tmux` and `zsh`.
- `readme` and `roadmap`, which titles of this repository use.
- Left out: `dotfiles` and `openspec` (`spec` replaces it).
- `.github/renovate.json` drops its labels and commit prefixes, so Renovate takes those of the shared preset: `chore(deps):`, `fix(deps):` and the label `scope/deps`.

All Conventional Commit types stay allowed. The scope check, the single commit check and the limit of 60 characters of the summary stay as they are.

The change fits one pull request.

## Capabilities

- `pr-title-scopes` (new): which scopes the title of a pull request of this repository can have.

## Impact

- The title check accepts each declared scope, in the title and in the subject of the one commit of a pull request.
- A pull request that is open now reads the new file only after its branch takes `main`.
- `devops gh label sync` creates each missing label and sets the color and the description of each declared label. It deletes no label.
- Intake can give an issue each declared `scope/*` label.

## Feasibility

Confirmed on 2026-11-26:

- `scripts/pr-title-scopes.sh` of dan-petty/infra at v0.24.2 prints the name after `scope/` of each `scope/*` label of the file, plus `main`. With yq v4.54.3 on the file of this change, it prints each declared scope.
- `.github/workflows/pr-title.yml` of dan-petty/infra passes that list to `amannn/action-semantic-pull-request` with `validateSingleCommit: true` and no list of types.
- `devops gh api repos/dan-petty/dotfiles/labels` lists the live `scope/*` labels, and the file declares each of them.
- The source of `devops gh label sync` in devops-cli (`sync_repository_labels`) creates and edits labels, and has no delete call.

## Existing Tool Considered

The shared title check of dan-petty/infra and `.github/labels.yml` cover the need. The change builds no code and deletes no code.
