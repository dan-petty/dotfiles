# Proposal

## Why

Issue #4 reports that `tmux/.tmux.conf:6` sets `default-terminal` to `xterm-256color`, which contradicts the tmux manual requirement that the value be screen, tmux, or a derivative. Programs in a pane then assume they talk to xterm directly. Since tmux 3.3, the build auto-selects the correct value, making the line both incorrect and unnecessary.

## What Changes

- Delete the `set -g default-terminal "xterm-256color"` line from `tmux/.tmux.conf`.
- Update the comment on the line above to reflect that tmux auto-selects default-terminal.
- Keep the `Tc` terminfo override for 24-bit colour.
- Add a test that asserts no xterm* value appears in a default-terminal setting and that the Tc override is present.
- The change fits one pull request.

## Capabilities

### New Capabilities

- `tmux-terminal-config`: default-terminal-must-not-be-xterm, tc-terminfo-override-preserved

### Modified Capabilities

None.

## Impact

- Code: `tmux/.tmux.conf`
- Tests: `tests/test_tmux_conf.sh`

## Feasibility

- The context confirms `tmux/.tmux.conf` exists and contains `set -g default-terminal "xterm-256color"`. The issue cites line 6 for this setting and line 7 for the Tc override.
- The fix is a two-line edit: delete the default-terminal line and update the adjacent comment. No new dependency or build step is needed.
- First checks the implementation runs: `grep -n 'default-terminal' tmux/.tmux.conf` to confirm the xterm line is present before the edit, and `grep -n 'Tc' tmux/.tmux.conf` to confirm the Tc override is present and must be preserved.

## Existing Tool Considered

No external tool or library is needed. The change edits a shell configuration file directly. The test is a shell script that uses `grep` to assert file contents.
