# Proposal

## Why

install.sh:38 links ~/.gitconfig to the tracked git/.gitconfig. Every git config --global write then edits the tracked file. This dirties the checkout and breaks git pull because git/.gitconfig:8-9 sets pull.rebase = true. See #2.

## What Changes

- Replace mkdir -p ${CONFIG_DIR}/starship with mkdir -p ${CONFIG_DIR}/git in install.sh
- Link git/.gitconfig to ${CONFIG_DIR}/git/config instead of ${HOME}/.gitconfig
- Link git/.gitignore_global to ${CONFIG_DIR}/git/ignore instead of ${HOME}/.gitignore_global
- Create ~/.gitconfig as an empty regular file; remove it first if it is a symlink from a prior install
- Delete the git config --global core.excludesfile line from install.sh
- Add a test script that verifies all five acceptance criteria from #2
- The change fits one pull request.

## Capabilities

### New Capabilities

- `dotfiles-install`: git-config-xdg-linking, git-global-config-isolation, git-global-ignore-linking, no-git-config-command

### Modified Capabilities

None.

## Impact

- Code: `install.sh`
- Tests: `tests/test_install_git_config.sh`

## Feasibility

- Confirmed against install.sh: line 38 calls link_file to symlink ~/.gitconfig to the tracked git/.gitconfig. Line 40 runs git config --global core.excludesfile. Line 17 creates an unused ${CONFIG_DIR}/starship directory. git/.gitconfig:8-9 sets pull.rebase = true.
- Git reads $XDG_CONFIG_HOME/git/config before ~/.gitconfig. Its default core.excludesFile for that path is ~/.config/git/ignore. This is documented in git-config(1). No external tool is needed.
- First checks the implementation runs: (1) HOME=$(mktemp -d) bash install.sh, then git config --global test.key 1, then git status --porcelain in the checkout; (2) git config --show-origin --get pull.rebase; (3) git check-ignore -v .DS_Store in a scratch repo; (4) test -f ~/.gitconfig && ! test -L ~/.gitconfig; (5) grep -n 'git config' install.sh expecting no match.

## Existing Tool Considered

Git itself provides the XDG config path ($XDG_CONFIG_HOME/git/config) and the default core.excludesFile (~/.config/git/ignore). No external library is needed. The change uses only bash builtins (mkdir, ln, rm, touch, test) and git's built-in config resolution order.
