# Dotfiles (`dan-petty/dotfiles`)

Personal development configurations, shell customizations, and automated bootstrapping for macOS, Linux, Devcontainers, and GitHub Codespaces.

---

## 🚀 Quickstart

### Automated Installation (Standalone)
```bash
git clone https://github.com/dan-petty/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

---

## 🐳 Devcontainers & GitHub Codespaces Integration

You can configure VS Code and GitHub Codespaces to automatically clone and apply these dotfiles in every devcontainer environment.

### VS Code Settings (`settings.json`)
```json
{
  "dotfiles.repository": "dan-petty/dotfiles",
  "dotfiles.targetPath": "~/dotfiles",
  "dotfiles.installCommand": "install.sh"
}
```

---

## 📁 Repository Structure

- `install.sh`: Idempotent installation & symlinking script.
- `zsh/`: Zsh shell configuration (`.zshrc`) and productivity aliases (`aliases.zsh`).
- `git/`: Global Git configuration (`.gitconfig`) and global ignores (`.gitignore_global`).
- `starship/`: Minimalist, high-visibility prompt configuration (`starship.toml`).
- `tmux/`: Terminal multiplexer configuration (`.tmux.conf`).

---

## 📄 License
MIT License. See [LICENSE](LICENSE) for details.
