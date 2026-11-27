# Tasks

## 1. Link the alias file during install

Kind: other. Reads: `install.sh`, `zsh/aliases.zsh`. Changes: `install.sh`.

- [x] 1.1 Add one link_file call to `install.sh` after the .zshrc link at `install.sh:35:link_file "${DOTFILES_DIR}/zsh/.zshrc" "${HOME}/.zshrc"`, so the shell section links `zsh/aliases.zsh` to `~/.aliases.zsh`. Keep the link_file helper and the order of the other sections unchanged, and run this check by hand: 1. Run T=$(mktemp -d), then run HOME="$T" ZDOTDIR="$T" XDG_CONFIG_HOME="$T/.config" GIT_CONFIG_GLOBAL="$T/gitconfig" ./install.sh from the root of the checkout, and confirm the log line that links zsh/aliases.zsh to "$T/.aliases.zsh". 2. Run test -L "$T/.aliases.zsh" and readlink "$T/.aliases.zsh", and confirm that the link points to zsh/aliases.zsh of the checkout. 3. Run HOME="$T" ZDOTDIR="$T" zsh -i -c 'alias ll' and confirm that it prints ll='ls -la --color=auto'; before the change it prints nothing and exits 1. 4. Run the install command of step 1 again, and confirm that the link stays and "$T" holds no .backup file. 5. Run git status --porcelain -- git/ and confirm that it prints nothing.

## 2. Source aliases only from the home directory

Kind: other. Reads: `zsh/.zshrc`, `install.sh`. Changes: `zsh/.zshrc`.

- [x] 2.1 Edit `zsh/.zshrc` and delete the fallback branch that builds a source path from `$0`: the `elif` test at line 37 and its source line at line 38. The alias block then holds the single `if` test of `~/.aliases.zsh` and one `source` line, so the file builds no source path from `$0` or the working directory. Leave the history, completion, prompt and PATH blocks unchanged, and run this check by hand: 1. Run T=$(mktemp -d), then run HOME="$T" ZDOTDIR="$T" XDG_CONFIG_HOME="$T/.config" GIT_CONFIG_GLOBAL="$T/gitconfig" ./install.sh from the root of the checkout. 2. Run HOME="$T" ZDOTDIR="$T" zsh -i -c 'alias ll' and confirm that it prints ll='ls -la --color=auto'. 3. Run rm -f "$T/.aliases.zsh", so that the home directory holds no alias file. 4. Run mkdir "$T/m" and write the one line echo ZSH_ALIAS_MARKER into "$T/m/aliases.zsh". 5. Run (cd "$T/m" && HOME="$T" ZDOTDIR="$T" zsh -i -c 'echo done') and confirm that the output is done with no ZSH_ALIAS_MARKER; the old startup file reaches its elif branch here and prints the marker, so the check fails before the fix. 6. From the root of the checkout, run ! git grep -n -E '\$\{?(0|PWD)' zsh/.zshrc and confirm that it finds no match; before the change it finds lines 37 and 38. 7. Run git status --porcelain -- git/ and confirm that it prints nothing.

## Criteria

- Group 1: After `./install.sh` with a fresh `HOME`, `zsh -i -c 'alias ll'` prints the alias.
- Group 2: A zsh started in a directory that contains an `aliases.zsh` that prints a marker does not print the marker.
- Group 2: `zsh/.zshrc` builds no source path from `$0` or the working directory.
