# Proposal

## Why

After ./install.sh the aliases of the checkout load only in a shell that starts in the checkout's `zsh/` directory, because `install.sh` creates no `~/.aliases.zsh` and `zsh/.zshrc` falls back to a path built from `$0`, which is the shell name during interactive startup. That fallback also sources any `aliases.zsh` in the directory where a shell starts, so a cloned repository can run code in the user's shell. Issue #1.

## What Changes

- `install.sh` gains one link_file call in its shell section that links the checkout's alias file to the home directory, so an install creates the file the startup file reads.
- `zsh/.zshrc` sources `~/.aliases.zsh` only and drops the branch that built a source path from `$0` and the working directory.
- The change alters what a shell user sees: the aliases load after an install, and a directory that holds an `aliases.zsh` runs no code. So it carries the spec delta of the new capability `shell-aliases`, and its scenarios name the live zsh check as their proof.
- The change fits one pull request.

## Capabilities

### New Capabilities

- `shell-aliases`: the installer links the alias file of the checkout to `~/.aliases.zsh`, and the startup file of zsh sources aliases only from that file.

### Modified Capabilities

None.

## Impact

- Code: `install.sh`, `zsh/.zshrc`
- Specs: the new capability `shell-aliases`

## Feasibility

- The probes confirm the cited paths word for word: "The path `install.sh` is a file of the staging commit.", "The path `zsh/aliases.zsh` is a file of the staging commit." and "The path `aliases.zsh` is no file at the root of the staging commit. These files of the commit are candidates: `zsh/aliases.zsh`. No commit in the history deleted or renamed it."
- `read_file install.sh` lines 15 to 50 shows the helper at `install.sh:19:link_file() {`, the link that writes a file, `install.sh:31:ln -sfn "${src}" "${dest}"`, and five link_file calls from `install.sh:35:link_file "${DOTFILES_DIR}/zsh/.zshrc" "${HOME}/.zshrc"` to `install.sh:46:link_file "${DOTFILES_DIR}/tmux/.tmux.conf" "${HOME}/.tmux.conf"`, with no call that links the alias file.
- `read_file zsh/.zshrc` lines 25 to 45 shows the first branch at `zsh/.zshrc:35:if [ -f "${HOME}/.aliases.zsh" ]; then` and the fallback that the issue reports at `zsh/.zshrc:37:elif [ -f "${0:A:h}/aliases.zsh" ]; then`, with its source line at `zsh/.zshrc:38: source "${0:A:h}/aliases.zsh"`.
- `git grep -n -E '\$\{?(0|PWD)' zsh/.zshrc` finds exactly lines 37 and 38 on the base, so the negative search `! git grep -n -E '\$\{?(0|PWD)' zsh/.zshrc` fails before the change and passes after it. The search of the issue, `grep -n '\$0' zsh/.zshrc`, finds no match on the base, because the file writes `${0:A:h}` and not `$0`, so it cannot fail.
- `search_code aliases.zsh` answers six hits: the structure entry `README.md:36:Zsh shell configuration` with the alias file in parentheses, the four lines 35 to 38 of `zsh/.zshrc`, and `zsh/aliases.zsh:2:# Shell Aliases (aliases.zsh)`. `README.md` stays unchanged by a decision, `zsh/.zshrc` is the change of group 2, and `zsh/aliases.zsh` stays unchanged by a decision.
- `read_file zsh/aliases.zsh` lines 1 to 12 confirms the alias that the acceptance check reads: `zsh/aliases.zsh:9:alias ll="ls -la --color=auto"`.
- `list_files` of the root lists `install.sh`, `zsh`, `README.md`, `openspec`, `.github` and no `tests` directory, no `pyproject.toml` and no `src` directory, so this repository holds no `uv run devops` project and no test suite.
- The premise is confirmed with zsh 5.9.2 and git 2.55 in a temporary home directory, with the base files: after ./install.sh, `zsh -i -c 'alias ll'` printed nothing and exited 1, a zsh started in a directory that holds an `aliases.zsh` with a marker printed the marker, and `alias ll` printed the alias only in a shell started in the checkout's `zsh/` directory. With the two planned edits, `alias ll` printed `ll='ls -la --color=auto'` and the marker stayed out.
- The marker check runs after the alias link is removed. `zsh/.zshrc:35:if [ -f "${HOME}/.aliases.zsh" ]; then` makes the first branch win whenever the alias link exists, so the check removes the link before it starts a zsh in a directory that holds a marker `aliases.zsh`; the old file then reaches the deleted `elif` and prints the marker, so the check fails before the fix and passes after it.
- `install.sh:38` links `~/.gitconfig` to the tracked `git/.gitconfig`, and `install.sh:40` runs `git config --global`. A run of ./install.sh in the checkout with only `HOME` changed wrote `excludesfile = <temporary home>/.gitignore_global` into the tracked `git/.gitconfig`. Each hand check sets `HOME`, `ZDOTDIR`, `XDG_CONFIG_HOME` and `GIT_CONFIG_GLOBAL` under one temporary directory, so it writes no file outside that directory and leaves `git/.gitconfig` unchanged. Issue #2 owns that link.
- No command of the verify grammar can run that zsh session: `list_files` of the root lists no `tests` directory and no `pyproject.toml`, so `uv run devops` has no project here, and the `! git grep` form only searches files. The manual check is the only check that runs a shell, and each of its steps is a shell command with a fixed result.
- `link_file` needs a checkout of the repository as a precondition: it links files of that checkout into the home directory, and ./install.sh runs it against a temporary home directory.
- Programs and runner capability: bash, zsh and git are in the runner image tools list, no program of the plan is NOT_IN_RUNNER, the manual check needs no network, no client and no cluster token, and the pod adds no capability and keeps a read-only root. The temporary home directory and the marker directory are writable.
- First checks against the real system, each with its command: `shellcheck install.sh` and `zsh -n zsh/.zshrc` pass on the base; the hand checks of groups 1 and 2 run ./install.sh with all four variables set under one temporary directory, then `zsh -i -c 'alias ll'` with the same variables, then `rm -f` of the alias link and a `zsh -i -c 'echo done'` started in a directory that holds an aliases.zsh with a marker.
- The issue builds as written: the probes show both cited files, the remedy is the one link call and the deletion of two lines, and the plan adds no compensating code and no compatibility path.

## Existing Tool Considered

No open tool covers this need. chezmoi, GNU Stow and dotbot manage their own symlink sets and would replace the repository's installer, and the alternatives check of 2026-11-12 found no relevant project. The change edits the two files that hold the defect and builds no new code. It deletes the fallback branch of `zsh/.zshrc` at lines 37 and 38.

## Dependencies

None.
