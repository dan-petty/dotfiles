# Tasks

## 1. Remove xterm-256color default-terminal and add validation test

Reads: none. Changes: `tmux/.tmux.conf`, `tests/test_tmux_conf.sh`.

- [x] 1.1 Write `tests/test_tmux_conf.sh`. The script runs `grep -n 'default-terminal.*xterm' tmux/.tmux.conf` and fails if a match is found. It also runs `grep -n 'Tc' tmux/.tmux.conf` and fails if no match is found. Run the script; it must fail on the current file because the xterm line is still present, and verify that `bash tests/test_tmux_conf.sh` fails on the base
- [x] 1.2 In `tmux/.tmux.conf`, delete the line `set -g default-terminal "xterm-256color"`. Update the comment on the preceding line to state that tmux 3.3+ auto-selects default-terminal. Keep the `Tc` terminfo override line unchanged. Re-run `tests/test_tmux_conf.sh`; it must pass, and verify that `bash tests/test_tmux_conf.sh` passes
- [x] 1.3 Change no document, run `uv run devops docs generate --sync-readme`, and verify that `uv run devops ci docs` passes

## Workflow follow-up

- Pending a person: review the diff in tuicr (tuicr -r <base>..HEAD).
