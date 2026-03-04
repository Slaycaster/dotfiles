#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname -s)"

info()  { printf "\033[34m[info]\033[0m  %s\n" "$1"; }
ok()    { printf "\033[32m[ok]\033[0m    %s\n" "$1"; }
warn()  { printf "\033[33m[warn]\033[0m  %s\n" "$1"; }
err()   { printf "\033[31m[error]\033[0m %s\n" "$1"; }

link_file() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -f "$dst" ] || [ -d "$dst" ]; then
    mv "$dst" "${dst}.bak"
    warn "Backed up existing $dst → ${dst}.bak"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  ok "Linked $dst → $src"
}

# ── Dependencies ──────────────────────────────────────────────
install_deps() {
  info "Installing dependencies..."

  if [[ "$OS" == "Darwin" ]]; then
    if ! command -v brew &>/dev/null; then
      info "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"
    fi
    brew install --quiet \
      neovim tmux starship fzf fd lazygit git-delta direnv ripgrep \
      ghostty 2>/dev/null || true
    ok "Homebrew packages installed"

  elif [[ "$OS" == "Linux" ]]; then
    if command -v apt-get &>/dev/null; then
      sudo apt-get update -qq
      sudo apt-get install -y -qq \
        fzf fd-find ripgrep direnv xclip curl git unzip 2>/dev/null || true
      ok "apt packages installed"

      # Manual installs for tools not in apt
      if ! command -v nvim &>/dev/null; then
        info "Installing Neovim..."
        curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz | \
          sudo tar -xz -C /usr/local --strip-components=1
        ok "Neovim installed"
      fi

      if ! command -v starship &>/dev/null; then
        info "Installing Starship..."
        curl -fsSL https://starship.rs/install.sh | sh -s -- -y
        ok "Starship installed"
      fi

      if ! command -v lazygit &>/dev/null; then
        info "Installing Lazygit..."
        LAZYGIT_VERSION=$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -fsSLo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar -xzf /tmp/lazygit.tar.gz -C /tmp lazygit
        sudo install /tmp/lazygit /usr/local/bin
        ok "Lazygit installed"
      fi

      if ! command -v delta &>/dev/null; then
        info "Installing delta..."
        DELTA_VERSION=$(curl -fsSL "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
        curl -fsSLo /tmp/delta.deb "https://github.com/dandavison/delta/releases/latest/download/git-delta_${DELTA_VERSION}_amd64.deb"
        sudo dpkg -i /tmp/delta.deb
        ok "Delta installed"
      fi
    fi
  fi
}

# ── Symlinks ──────────────────────────────────────────────────
link_configs() {
  info "Linking configs..."

  # Shell
  if [[ "$OS" == "Darwin" ]]; then
    link_file "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
  else
    link_file "$DOTFILES/bash/.bashrc" "$HOME/.bashrc"
    # Also link zshrc in case zsh is used on Linux
    link_file "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
  fi

  # Tmux
  link_file "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"

  # Neovim
  link_file "$DOTFILES/nvim" "$HOME/.config/nvim"

  # Starship
  link_file "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"

  # Lazygit
  mkdir -p "$HOME/.config/lazygit"
  link_file "$DOTFILES/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"

  # Git
  link_file "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"

  # Ghostty
  if [[ "$OS" == "Darwin" ]]; then
    link_file "$DOTFILES/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
  else
    link_file "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/config"
  fi
}

# ── TPM (tmux plugin manager) ────────────────────────────────
install_tpm() {
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    info "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    ok "TPM installed (press C-a I in tmux to install plugins)"
  else
    ok "TPM already installed"
  fi
}

# ── NVM ───────────────────────────────────────────────────────
install_nvm() {
  if [ ! -d "$HOME/.nvm" ]; then
    info "Installing NVM..."
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    ok "NVM installed"
  else
    ok "NVM already installed"
  fi
}

# ── Font reminder ─────────────────────────────────────────────
font_reminder() {
  echo ""
  info "Don't forget to install a Nerd Font!"
  echo "  → https://www.nerdfonts.com/font-downloads"
  echo "  → Recommended: JetBrainsMono Nerd Font"
  echo ""
  if [[ "$OS" == "Darwin" ]]; then
    echo "  brew install --cask font-jetbrains-mono-nerd-font"
  fi
}

# ── Main ──────────────────────────────────────────────────────
main() {
  echo ""
  echo "  ╔══════════════════════════════════╗"
  echo "  ║     Den's Dotfiles Installer     ║"
  echo "  ║         Tokyo Night 🌃           ║"
  echo "  ╚══════════════════════════════════╝"
  echo ""

  read -rp "Install dependencies? (y/n) " install_deps_answer
  [[ "$install_deps_answer" =~ ^[Yy]$ ]] && install_deps

  link_configs
  install_tpm
  install_nvm
  font_reminder

  echo ""
  ok "All done! Restart your terminal or run: source ~/.zshrc (or ~/.bashrc)"
  echo ""
}

main "$@"
