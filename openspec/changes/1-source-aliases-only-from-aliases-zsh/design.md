# Design

## Decisions

- **Link the alias file with the existing link_file helper instead of copying it.**: `install.sh:19:link_file() {` shows one helper links every dotfile of the repository, and its backup rule replaces an old file; a link keeps `zsh/aliases.zsh` the only copy.
- **Delete the fallback branch instead of repairing it.**: The install now creates the file the first branch tests, so the fallback is dead code, and any source path built from the shell's start state is the injection the issue reports.
- **Leave `zsh/aliases.zsh` unchanged.**: The file is the source the installer links, and its alias at `zsh/aliases.zsh:9:alias ll="ls -la --color=auto"` is the behavior the acceptance check reads.
- **Leave `README.md` unchanged.**: The structure entry at `README.md:36:Zsh shell configuration` lists `.zshrc` and `aliases.zsh` and stays true; the new home link adds no entry to that checkout structure.
- **Run the marker check with the installed startup file but no `~/.aliases.zsh`.**: `zsh/.zshrc:35:if [ -f "${HOME}/.aliases.zsh" ]; then` makes the first branch win whenever the alias link exists, so the check removes the link before it starts the zsh in the marker directory; only then does the deleted `elif` decide the outcome.
- **Check the live zsh behavior with a repeatable manual check in group 2.**: `list_files` of the root lists no `tests` directory and no `pyproject.toml`, so `uv run devops` has no project here and the `! git grep` form only searches files; the manual check installs into a fresh HOME, removes the alias link, starts a zsh in a directory that holds a marker `aliases.zsh`, asserts the marker is absent, and asserts that `alias ll` still prints.
- **Carry no spec delta for the change.**: `list_files` of the root lists no `tests` directory and no `src` directory, so no behavior test can cover a shell scenario, and the living spec of the repository describes pull request titles only.

## Rejected alternatives

- **Copy zsh/aliases.zsh into ~/.aliases.zsh during install.**: `install.sh:31:ln -sfn "${src}" "${dest}"` is how every dotfile lands in the home directory; a copy would drift from the checkout and would need its own update step.
- **Repair the fallback with a zsh-specific path such as ${(%):-%x}.**: `install.sh:35:link_file "${DOTFILES_DIR}/zsh/.zshrc" "${HOME}/.zshrc"` puts the startup file in the home directory, so a path resolved from that file is the home directory, which the first branch already covers.
- **Keep the checkout fallback so a shell started inside the checkout finds the aliases.**: `zsh/.zshrc:37:elif [ -f "${0:A:h}/aliases.zsh" ]; then` sources a file of whatever directory the shell starts in, which is the code execution the issue reports; the installer link covers every installed shell.

## Unchanged references

- `README.md` (documentation mention): The structure entry for zsh/ names the alias file and stays true; the installer link adds no new path to that list.
- `zsh/aliases.zsh` (linked alias file): The installer links this file and the change edits no alias.
