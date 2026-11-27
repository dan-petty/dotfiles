# Design

## Decisions

- **Link the alias file with the existing link_file helper instead of copying it.**: `install.sh:19:link_file() {` shows one helper links every dotfile of the repository, and its backup rule replaces an old file; a link keeps `zsh/aliases.zsh` the only copy.
- **Delete the fallback branch instead of repairing it.**: The install now creates the file the first branch tests, so the fallback is dead code, and any source path built from the shell's start state is the injection the issue reports.
- **Leave `zsh/aliases.zsh` unchanged.**: The file is the source the installer links, and its alias at `zsh/aliases.zsh:9:alias ll="ls -la --color=auto"` is the behavior the acceptance check reads.
- **Leave `README.md` unchanged.**: The structure entry at `README.md:36:Zsh shell configuration` lists `.zshrc` and `aliases.zsh` and stays true; the new home link adds no entry to that checkout structure.
- **Run the marker check with the installed startup file but no `~/.aliases.zsh`.**: `zsh/.zshrc:35:if [ -f "${HOME}/.aliases.zsh" ]; then` makes the first branch win whenever the alias link exists, so the check removes the link before it starts the zsh in the marker directory; only then does the deleted `elif` decide the outcome.
- **Check the live zsh behavior with a repeatable manual check in group 2.**: `list_files` of the root lists no `tests` directory and no `pyproject.toml`, so `uv run devops` has no project here and the `! git grep` form only searches files; the manual check installs into a temporary home directory, asserts that `alias ll` prints, removes the alias link, starts a zsh in a directory that holds a marker `aliases.zsh`, and asserts that the marker is absent.
- **Keep every write of a hand check in one temporary directory.**: `install.sh:38` links `~/.gitconfig` to the tracked `git/.gitconfig` and `install.sh:40` runs `git config --global`, so a run with only `HOME` changed wrote a temporary path into the tracked file. `GIT_CONFIG_GLOBAL` sends that write to the temporary directory, `XDG_CONFIG_HOME` keeps the starship link there, and `ZDOTDIR` makes zsh read the installed startup file and no other.
- **Carry the spec delta of the new capability `shell-aliases`.**: `openspec/config.yaml` lets a change skip specs only when it alters no behavior a consumer observes, and this change alters which aliases a shell defines and which files it sources. The spec rule lets a scenario of a config file name a live check as its proof, and a zsh in a temporary home directory runs that check offline.

## Rejected alternatives

- **Copy zsh/aliases.zsh into ~/.aliases.zsh during install.**: `install.sh:31:ln -sfn "${src}" "${dest}"` is how every dotfile lands in the home directory; a copy would drift from the checkout and would need its own update step.
- **Repair the fallback with a zsh-specific path such as ${(%):-%x}.**: In `~/.zshrc`, `${${(%):-%x}:A:h}` follows the link that `install.sh:35:link_file "${DOTFILES_DIR}/zsh/.zshrc" "${HOME}/.zshrc"` makes and gives the checkout's `zsh/` directory, so the repair works. It keeps a second source path that depends on how the startup file was installed: a copied `.zshrc` resolves to the home directory and sources `~/aliases.zsh`, a file that no installer writes. One fixed path, the link that the installer makes, is the only path to audit.
- **Keep the checkout fallback so a shell started inside the checkout finds the aliases.**: `zsh/.zshrc:37:elif [ -f "${0:A:h}/aliases.zsh" ]; then` sources a file of whatever directory the shell starts in, which is the code execution the issue reports; the installer link covers every installed shell.
- **Run the hand checks with only `HOME` changed.**: A run of ./install.sh in the checkout with only `HOME` changed added `excludesfile = <temporary home>/.gitignore_global` to the tracked `git/.gitconfig`, through the link of `install.sh:38`.
- **Set skip_specs for the change.**: The rule of `openspec/config.yaml` keeps skip_specs for tests, CI workflows, documents and refactors that keep behavior; after this change a new shell defines the aliases and a directory that holds an `aliases.zsh` runs no code.

## Unchanged references

- `README.md` (documentation mention): The structure entry for zsh/ names the alias file and stays true; the installer link adds no new path to that list.
- `zsh/aliases.zsh` (linked alias file): The installer links this file and the change edits no alias.
