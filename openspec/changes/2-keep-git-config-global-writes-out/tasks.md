# Tasks

## 1. Fix git config linking and add test

Reads: none. Changes: `install.sh`, `tests/test_install_git_config.sh`.

- [x] 1.1 Write tests/test_install_git_config.sh. It sets a temporary HOME, runs install.sh, then asserts: (1) git config --global test.key 1 writes to ~/.gitconfig and git status --porcelain in the checkout is empty; (2) git config --show-origin --get pull.rebase reports the XDG path; (3) git check-ignore -v .DS_Store in a scratch repo reports the XDG ignore path; (4) after simulating a prior install symlink, ~/.gitconfig is a regular file not a symlink; (5) grep -n 'git config' install.sh returns no match. The test fails before the implementation because install.sh still links ~/.gitconfig and runs git config --global, and verify that `bash tests/test_install_git_config.sh` fails on the base
- [x] 1.2 In install.sh: (1) Replace mkdir -p "${CONFIG_DIR}/starship" with mkdir -p "${CONFIG_DIR}/git". (2) In the Git section, replace link_file "${DOTFILES_DIR}/git/.gitconfig" "${HOME}/.gitconfig" with link_file "${DOTFILES_DIR}/git/.gitconfig" "${CONFIG_DIR}/git/config". (3) Replace link_file "${DOTFILES_DIR}/git/.gitignore_global" "${HOME}/.gitignore_global" with link_file "${DOTFILES_DIR}/git/.gitignore_global" "${CONFIG_DIR}/git/ignore". (4) Delete the line git config --global core.excludesfile "${HOME}/.gitignore_global" || true. (5) After the two link_file calls, add: if [ -L "${HOME}/.gitconfig" ]; then rm -f "${HOME}/.gitconfig"; fi; if [ ! -f "${HOME}/.gitconfig" ]; then touch "${HOME}/.gitconfig"; fi. This removes a prior-install symlink, creates an empty regular file if missing, and leaves an existing regular file untouched, and verify that `bash tests/test_install_git_config.sh` passes
- [x] 1.3 Change no document, run `uv run devops docs generate --sync-readme`, and verify that `uv run devops ci docs` passes

## Workflow follow-up

- Pending a person: review the diff in tuicr (tuicr -r <base>..HEAD).
