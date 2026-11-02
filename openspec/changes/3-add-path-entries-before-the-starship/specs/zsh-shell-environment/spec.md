## Purpose
Defines the PATH setup order and prompt tool initialization for the zsh interactive shell configuration file.

## ADDED Requirements

### Requirement: PATH entries are set before prompt tool checks
The PATH additions block SHALL appear before the starship availability check in zsh/.zshrc so that a shell with a minimal inherited PATH can find starship in ~/.local/bin.

#### Scenario: starship found with minimal inherited PATH
- **WHEN** a new interactive zsh shell starts with PATH=/usr/bin:/bin, a stub starship exists only in ~/.local/bin, and zsh is run with -o no_global_rcs -i
- **THEN** command -v starship resolves to the stub path in ~/.local/bin

### Requirement: PATH entries are unique in nested shells
The zshrc SHALL mark both PATH and path as unique with typeset -U before the export assignment so that each directory appears only once in nested shells.

#### Scenario: no duplicate PATH entries in nested shell
- **WHEN** a zsh shell is started from another zsh shell that already sourced the same .zshrc
- **THEN** print -l $path | sort | uniq -d produces no output
