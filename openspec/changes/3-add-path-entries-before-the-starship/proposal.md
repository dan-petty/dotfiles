# Proposal

## Why

Issue #3 reports that zsh/.zshrc:30 checks for starship before zsh/.zshrc:42 adds ~/.local/bin and ~/bin to PATH. A shell with a minimal inherited PATH cannot find starship, so the prompt stays plain. The same line also prepends three directories in every nested shell, creating duplicates.

## What Changes

- Move the PATH additions block (lines 41-42) above the starship check (line 30) in zsh/.zshrc.
- Add typeset -U PATH path immediately before the export PATH assignment to deduplicate entries.
- Add a test script that verifies starship is found with a minimal PATH and that nested shells have no duplicate PATH entries.
- The change fits one pull request.

## Capabilities

### New Capabilities

- `zsh-shell-environment`: PATH entries are set before prompt tool checks, PATH entries are unique in nested shells

### Modified Capabilities

None.

## Impact

- Code: `zsh/.zshrc`
- Tests: `tests/test_zshrc.sh`

## Feasibility

- The issue premise is confirmed by the context: zsh/.zshrc:30 shows the starship check and zsh/.zshrc:42 shows the PATH export below it. The identifier matches confirm the line numbers at commit 7d80c91.
- The issue body states that typeset -U path alone does not remove duplicates from a scalar export PATH=... assignment, and that both PATH and path must be marked unique. This is consistent with zsh documentation.
- First checks the implementation runs: (1) grep -n 'PATH\|starship' zsh/.zshrc to confirm the PATH export line number is less than the starship check line number. (2) grep -n 'typeset -U' zsh/.zshrc to confirm the typeset line is before the export line. (3) PATH=/usr/bin:/bin zsh -o no_global_rcs -i -c 'command -v starship' with a stub starship in a temp HOME to confirm starship is found. (4) Start a nested zsh and run print -l $path | sort | uniq -d to confirm no duplicates.

## Existing Tool Considered

No external tool covers reordering two blocks in a shell config file. The change edits one existing file (zsh/.zshrc) with roughly 5 lines moved and 1 line added. No internal code is deleted. The cost to build, keep, and fix is under 200 tokens of file content and one test script of about 40 lines.
