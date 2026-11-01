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
mkdir -p "${CONFIG_DIR}/git"

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
link_file "${DOTFILES_DIR}/git/.gitconfig" "${CONFIG_DIR}/git/config"
link_file "${DOTFILES_DIR}/git/.gitignore_global" "${CONFIG_DIR}/git/ignore"

# 3. Starship Prompt
link_file "${DOTFILES_DIR}/starship/starship.toml" "${CONFIG_DIR}/starship.toml"

# 4. Tmux
link_file "${DOTFILES_DIR}/tmux/.tmux.conf" "${HOME}/.tmux.conf"

# Ensure ~/.gitconfig exists as a regular file (not symlink) to capture global writes
if [ -L "${HOME}/.gitconfig" ]; then
    rm -f "${HOME}/.gitconfig"
fi
if [ ! -f "${HOME}/.gitconfig" ]; then
    touch "${HOME}/.gitconfig"
fi

echo "======================================================"
echo " ✓ Dotfiles installation complete!"
echo "======================================================"
