# Tasks

## 1. Link the alias file during install

Kind: other. Reads: `install.sh`, `zsh/aliases.zsh`. Changes: `install.sh`.

- [ ] 1.1 Add one link_file call to `install.sh` after the .zshrc link at `install.sh:35:link_file "${DOTFILES_DIR}/zsh/.zshrc" "${HOME}/.zshrc"`, so the shell section links `zsh/aliases.zsh` to `~/.aliases.zsh`. Keep the link_file helper and the order of the other sections unchanged, and run this check by hand: With a fresh HOME and no ~/.aliases.zsh, run ./install.sh and confirm the log line that links zsh/aliases.zsh to ~/.aliases.zsh. Run test -L "${HOME}/.aliases.zsh" and readlink "${HOME}/.aliases.zsh", then run zsh -i -c 'alias ll' and confirm it prints ll='ls -la --color=auto'. Run ./install.sh a second time and confirm the link stays and no .backup file appears.

## 2. Source aliases only from the home directory

Kind: other. Reads: `zsh/.zshrc`, `install.sh`. Changes: `zsh/.zshrc`.

- [ ] 2.1 Edit `zsh/.zshrc` and delete the fallback branch that builds a source path from `$0`: the `elif` test at line 37 and its source line at line 38. The alias block then holds the single `if` test of `~/.aliases.zsh` and one `source` line, so the file builds no source path from `$0` or the working directory. Leave the history, completion, prompt and PATH blocks unchanged, and run this check by hand: Create a temporary HOME directory and run ./install.sh with HOME set to it. Run zsh -i -c 'alias ll' and confirm it prints ll='ls -la --color=auto'. Remove the link with rm -f "${HOME}/.aliases.zsh", so the home directory holds no alias file. Create a second temporary directory that holds an aliases.zsh whose body prints ZSH_ALIAS_MARKER, change into it, and run zsh -i -c 'echo done' with the same HOME. Confirm the output prints done and no ZSH_ALIAS_MARKER; the old startup file reaches its elif branch here and prints the marker, so the check fails before the fix. Run ! git grep -n -F 0:A:h zsh/.zshrc and confirm it finds no match.

## Criteria

- Group 1: After `./install.sh` with a fresh `HOME`, `zsh -i -c 'alias ll'` prints the alias.
- Group 2: A zsh started in a directory that contains an `aliases.zsh` that prints a marker does not print the marker.
- Group 2: `zsh/.zshrc` builds no source path from `$0` or the working directory.
