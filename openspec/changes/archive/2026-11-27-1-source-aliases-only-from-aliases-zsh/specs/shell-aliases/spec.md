## Purpose

An interactive zsh that uses these dotfiles defines the aliases of the checkout. The shell sources aliases only from the file `~/.aliases.zsh` that the installer links, and never from the directory where the shell starts.

## ADDED Requirements

### Requirement: The installer links the alias file
The installer SHALL link the alias file `zsh/aliases.zsh` of the checkout to `~/.aliases.zsh`, so that an interactive zsh defines the aliases after an install.

#### Scenario: An empty home directory gets the aliases
- **WHEN** the installer runs with `HOME` set to an empty directory.
- **THEN** `~/.aliases.zsh` is a link to `zsh/aliases.zsh`, `git grep -n -F 'zsh/aliases.zsh' install.sh` finds the link call, and `zsh -i -c 'alias ll'` with that `HOME` prints `ll='ls -la --color=auto'`.

### Requirement: The startup file sources aliases only from the home directory
The startup file of zsh SHALL source aliases only from `~/.aliases.zsh`. It SHALL NOT build a source path from `$0` or from the working directory.

#### Scenario: A directory with an alias file runs no code
- **WHEN** an interactive zsh starts in a directory that holds an `aliases.zsh` that prints a marker, and the home directory holds no `~/.aliases.zsh`.
- **THEN** the shell does not print the marker, and `git grep -n -E '\$\{?(0|PWD)' zsh/.zshrc` finds no match.
