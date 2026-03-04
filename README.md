# Den's Dotfiles 🌃

Unified terminal config for WSL2 (bash) and macOS (zsh). Tokyo Night everything.

## What's included

- **zsh/bash** — aliases, fzf (Tokyo Night), direnv, nvm
- **tmux** — `C-a` prefix, vim nav, Tokyo Night status bar, TPM
- **nvim** — LazyVim + Tokyo Night, treesitter, telescope, tmux-navigator
- **starship** — powerline prompt with Tokyo Night palette
- **lazygit** — Tokyo Night theme, delta pager, nerd fonts
- **ghostty** — Tokyo Night terminal colors
- **git** — delta pager, sensible defaults

## Install

```bash
git clone https://github.com/Slaycaster/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The installer detects macOS vs Linux and handles deps + symlinks automatically.

## Post-install

1. Install [JetBrainsMono Nerd Font](https://www.nerdfonts.com/)
   - macOS: `brew install --cask font-jetbrains-mono-nerd-font`
2. Open tmux → `C-a I` to install plugins
3. Open nvim → plugins auto-install on first launch

## Structure

```
├── install.sh        # Cross-platform installer
├── bash/.bashrc      # Bash config (WSL2)
├── zsh/.zshrc        # Zsh config (macOS)
├── tmux/.tmux.conf   # Tmux config
├── nvim/             # Neovim (LazyVim)
├── starship/         # Starship prompt
├── lazygit/          # Lazygit
├── ghostty/          # Ghostty terminal
└── git/.gitconfig    # Git config
```
