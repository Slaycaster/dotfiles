# -- Den's Zsh Config --
# Works on macOS + Linux (WSL2)

# -- History --
HISTSIZE=10000
SAVEHIST=20000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# -- Options --
setopt AUTO_CD
setopt CORRECT
setopt NO_BEEP

# -- Completion --
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select

# -- Vi mode (optional, uncomment if you want it) --
# bindkey -v

# -- Aliases --
alias v='nvim'
alias n='nvim'
alias lg='lazygit'
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias t='tmux'
alias cl='claude --dangerously-skip-permissions'
alias ca='cursor-agent'

# macOS ls doesn't support --color=auto the same way
if [[ "$(uname)" == "Darwin" ]]; then
  alias ll='ls -lah -G'
  alias la='ls -A -G'
fi

# -- NVM --
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# -- PATH --
export PATH="$HOME/.local/bin:$HOME/.bun/bin:$PATH"

# -- Platform-specific --
if [[ "$(uname)" == "Darwin" ]]; then
  # macOS: Homebrew
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"
else
  # Linux/WSL2
  export ANDROID_HOME="$HOME/android-sdk"
  [ -d "$ANDROID_HOME" ] && export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools"
  export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
fi

# -- fzf Tokyo Night --
export FZF_DEFAULT_OPTS="
  --color=bg+:#292e42,bg:#1a1b26,spinner:#7aa2f7,hl:#7aa2f7
  --color=fg:#a9b1d6,header:#7aa2f7,info:#e0af68,pointer:#7aa2f7
  --color=marker:#9ece6a,fg+:#c0caf5,prompt:#7aa2f7,hl+:#7aa2f7
  --border rounded
  --layout=reverse
  --info=inline"

# fzf uses fd on macOS, fdfind on Debian/Ubuntu
if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
elif command -v fdfind &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
if command -v fd &>/dev/null; then
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
elif command -v fdfind &>/dev/null; then
  export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'
fi

# fzf keybindings & completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Homebrew fzf
[ -f "$(brew --prefix 2>/dev/null)/opt/fzf/shell/key-bindings.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
[ -f "$(brew --prefix 2>/dev/null)/opt/fzf/shell/completion.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
# apt fzf
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh

# -- direnv --
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

# -- Starship prompt --
eval "$(starship init zsh)"
