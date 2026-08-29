# =============================================================================
# Personal Zsh Configuration (.zshrc)
# =============================================================================

# History settings
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Completion system
autoload -Uz compinit && compinit -C
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

# Prompt (Starship)
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# Load Aliases
if [ -f "${HOME}/.aliases.zsh" ]; then
    source "${HOME}/.aliases.zsh"
elif [ -f "${0:A:h}/aliases.zsh" ]; then
    source "${0:A:h}/aliases.zsh"
fi

# PATH additions
export PATH="${HOME}/.local/bin:${HOME}/bin:/usr/local/bin:${PATH}"
