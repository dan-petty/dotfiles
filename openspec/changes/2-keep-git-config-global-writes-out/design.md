# Design

## Decisions

- **Link tracked git settings to ${CONFIG_DIR}/git/config (the XDG path) instead of ~/.gitconfig**: Git reads the XDG config path before ~/.gitconfig. This keeps tracked settings active while isolating --global writes to the untracked ~/.gitconfig file.
- **Create ~/.gitconfig as an empty regular file rather than a symlink**: Git writes --global settings to ~/.gitconfig when it exists. An empty regular file captures those writes without touching the tracked checkout. A prior-install symlink must be removed first.
- **Link git/.gitignore_global to ${CONFIG_DIR}/git/ignore**: Git's default core.excludesFile for the XDG config path is ~/.config/git/ignore. Linking the tracked ignore file there makes the explicit git config --global write unnecessary.
- **Delete the git config --global core.excludesfile line from install.sh**: The XDG default already points to the correct ignore path. The line is redundant and the acceptance criteria forbid any git config call in install.sh.
- **Replace the unused mkdir -p ${CONFIG_DIR}/starship with mkdir -p ${CONFIG_DIR}/git**: The starship subdirectory is never used because starship.toml is linked directly into ${CONFIG_DIR}. The git subdirectory is required for the new symlink targets.

## Rejected alternatives

- **Keep linking ~/.gitconfig to the tracked git/.gitconfig**: install.sh:38 does this today. Every git config --global write (gh auth setup-git, VS Code Dev Containers) edits the tracked file. git/.gitconfig:8-9 sets pull.rebase = true, so unstaged changes block git pull. The issue reproduces this with git 2.55.
- **Copy tracked git config content into ~/.gitconfig as a regular file**: This breaks the dotfiles symlink model. Updates to the tracked file do not propagate to the copy. The user must re-run install.sh after every change.
- **Keep the git config --global core.excludesfile line but let it write to the now-regular ~/.gitconfig**: The acceptance criteria in #2 state install.sh runs no git config command. The XDG default core.excludesFile already points to ~/.config/git/ignore, making the line redundant.
- **Keep both mkdir lines (starship and git)**: The starship subdirectory is unused. starship.toml is linked directly to ${CONFIG_DIR}/starship.toml (install.sh:42). Keeping the line creates an empty, unused directory.
