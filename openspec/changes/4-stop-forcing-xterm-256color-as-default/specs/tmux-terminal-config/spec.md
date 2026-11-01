## Purpose
Defines the terminal type and colour configuration for tmux panes in the dotfiles repository.

## ADDED Requirements

### Requirement: default-terminal-must-not-be-xterm
The tmux configuration file SHALL NOT set default-terminal to a value matching xterm*.

#### Scenario: no xterm default-terminal in config
- **WHEN** the file tmux/.tmux.conf is searched for a default-terminal line with an xterm value
- **THEN** no line matches the pattern default-terminal.*xterm

### Requirement: tc-terminfo-override-preserved
The tmux configuration file SHALL retain a Tc terminfo override for 24-bit colour.

#### Scenario: Tc override is present
- **WHEN** the file tmux/.tmux.conf is searched for a Tc terminfo setting
- **THEN** at least one line contains a Tc terminfo override
