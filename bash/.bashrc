# -- Den's Bash Config --
# Primarily for WSL2/Linux

# Non-interactive bail
case $- in
  *i*) ;;
  *) return ;;
esac

# -- History --
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000

# -- Shell options --
shopt -s checkwinsize

# -- Prompt colors --
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes ;;
esac

# -- Completion --
if ! shopt -oq posix; then
  [ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
  [ -f /etc/bash_completion ] && . /etc/bash_completion
fi

# -- Aliases --
alias v='nvim'
alias n='nvim'
alias lg='lazygit'
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias t='tmux'
alias cl='claude --dangerously-skip-permissions'
alias ca='cursor-agent'

# -- NVM --
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# -- PATH --
export PATH="$HOME/.local/bin:$HOME/.bun/bin:$PATH"

# -- Platform-specific --
export ANDROID_HOME="$HOME/android-sdk"
[ -d "$ANDROID_HOME" ] && export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools"
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64

# -- fzf Tokyo Night --
export FZF_DEFAULT_OPTS="
  --color=bg+:#292e42,bg:#1a1b26,spinner:#7aa2f7,hl:#7aa2f7
  --color=fg:#a9b1d6,header:#7aa2f7,info:#e0af68,pointer:#7aa2f7
  --color=marker:#9ece6a,fg+:#c0caf5,prompt:#7aa2f7,hl+:#7aa2f7
  --border rounded
  --layout=reverse
  --info=inline"

if command -v fdfind &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
elif command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
if command -v fdfind &>/dev/null; then
  export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'
elif command -v fd &>/dev/null; then
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash

# -- direnv --
command -v direnv &>/dev/null && eval "$(direnv hook bash)"

# -- Starship prompt --
eval "$(starship init bash)"

# Disable bracketed paste (fixes some terminal quirks in WSL2)
printf '\e[?2004l'
