# Tasks

## 1. Reorder PATH and starship blocks, add typeset -U, and add test

Reads: none. Changes: `zsh/.zshrc`, `tests/test_zshrc.sh`.

- [ ] 1.1 Write tests/test_zshrc.sh. The script creates a temporary HOME directory. It places a stub starship executable in $HOME/.local/bin. It runs PATH=/usr/bin:/bin zsh -o no_global_rcs -i -c 'command -v starship' and asserts the output is the stub path. It then starts a nested zsh and runs print -l $path | sort | uniq -d, asserting the output is empty. It also greps zsh/.zshrc to assert the PATH export line number is less than the starship check line number, and that a typeset -U line exists before the export line, and verify that `bash tests/test_zshrc.sh` fails on the base
- [ ] 1.2 Edit zsh/.zshrc. Move the comment line '# PATH additions' and the line 'export PATH="${HOME}/.local/bin:${HOME}/bin:/usr/local/bin:${PATH}"' to appear before the line 'if command -v starship &>/dev/null; then'. Insert 'typeset -U PATH path' on the line immediately before the export PATH assignment. Keep all other lines in their original order, and verify that `bash tests/test_zshrc.sh` passes
- [ ] 1.3 Change no document, run `uv run devops docs generate --sync-readme`, and verify that `uv run devops ci docs` passes

## Workflow follow-up

- Pending a person: review the diff in tuicr (tuicr -r <base>..HEAD).
