#!/usr/bin/env bash
# =============================================================================
# Dotfiles Installation & Symlink Bootstrapper
# Compatible with macOS, Linux, Devcontainers, and GitHub Codespaces
# =============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

echo "======================================================"
echo " Installing dotfiles from: ${DOTFILES_DIR}"
echo "======================================================"

mkdir -p "${CONFIG_DIR}"
mkdir -p "${CONFIG_DIR}/starship"

link_file() {
    local src="$1"
    local dest="$2"

    if [ -L "${dest}" ]; then
        rm -f "${dest}"
    elif [ -f "${dest}" ] || [ -d "${dest}" ]; then
        echo "Backing up existing ${dest} to ${dest}.backup"
        mv "${dest}" "${dest}.backup"
    fi

    echo "Linking ${src} -> ${dest}"
    ln -sfn "${src}" "${dest}"
}

# 1. Shell (Zsh)
link_file "${DOTFILES_DIR}/zsh/.zshrc" "${HOME}/.zshrc"

# 2. Git
link_file "${DOTFILES_DIR}/git/.gitconfig" "${HOME}/.gitconfig"
link_file "${DOTFILES_DIR}/git/.gitignore_global" "${HOME}/.gitignore_global"
git config --global core.excludesfile "${HOME}/.gitignore_global" || true

# 3. Starship Prompt
link_file "${DOTFILES_DIR}/starship/starship.toml" "${CONFIG_DIR}/starship.toml"

# 4. Tmux
link_file "${DOTFILES_DIR}/tmux/.tmux.conf" "${HOME}/.tmux.conf"

echo "======================================================"
echo " ✓ Dotfiles installation complete!"
echo "======================================================"
