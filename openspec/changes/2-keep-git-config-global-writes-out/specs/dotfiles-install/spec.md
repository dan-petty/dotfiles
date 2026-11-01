## Purpose
Defines the observable behavior of the dotfiles installation script, including how configuration files are linked, how git settings are applied, and how the checkout stays clean after install.

## ADDED Requirements

### Requirement: git-config-xdg-linking
The install script SHALL link the tracked git/.gitconfig file to the XDG config path ${CONFIG_DIR}/git/config.

#### Scenario: fresh install links to XDG path
- **WHEN** install.sh runs with a fresh HOME and CONFIG_DIR defaults to ~/.config
- **THEN** ~/.config/git/config is a symlink to the tracked git/.gitconfig file, and git config --show-origin --get pull.rebase reports ~/.config/git/config as the origin

### Requirement: git-global-config-isolation
The install script SHALL create ~/.gitconfig as an empty regular file. It SHALL remove ~/.gitconfig first if it is a symlink left by a prior install.

#### Scenario: fresh install creates regular file
- **WHEN** install.sh runs with a fresh HOME where ~/.gitconfig does not exist
- **THEN** ~/.gitconfig exists as a regular file (test -f succeeds) and is not a symlink (test -L fails)

#### Scenario: prior install symlink is removed
- **WHEN** ~/.gitconfig is a symlink to the tracked git/.gitconfig and install.sh runs
- **THEN** ~/.gitconfig is a regular file and is not a symlink

#### Scenario: global write stays on machine
- **WHEN** install.sh has run and git config --global test.key 1 is executed
- **THEN** the key test.key appears in ~/.gitconfig and git status --porcelain in the dotfiles checkout prints nothing

### Requirement: git-global-ignore-linking
The install script SHALL link the tracked git/.gitignore_global file to ${CONFIG_DIR}/git/ignore.

#### Scenario: ignore file at XDG path
- **WHEN** install.sh runs with a fresh HOME and a scratch git repository is created
- **THEN** git check-ignore -v .DS_Store reports the rule from ~/.config/git/ignore

### Requirement: no-git-config-command
The install script SHALL NOT execute any git config command.

#### Scenario: no git config in script
- **WHEN** the text of install.sh is searched for the string 'git config'
- **THEN** no line matches
