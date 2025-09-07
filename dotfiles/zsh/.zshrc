source $ZDOTDIR/path

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

eval "$(starship init zsh)"

# Keybindings
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey "^[[A" history-beginning-search-backward #up
bindkey "^[[B" history-beginning-search-forward #down
bindkey '^[w' kill-region

# History
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls="eza"
alias l="ls -lbF"
alias ll="ls -la"
alias llm="ll --sort=modified"
alias la="ls -lbhHigUmuSa"
alias lx="ls -lbhHigUmuSa@"
alias tree="eza --tree"
alias lS="eza -1"
alias gs="git status"
alias ga="git add"
alias gaa="git add ."
alias gc="git commit"
alias gcm="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gl="git log"
alias gg="lazygit"
alias vim='nvim'
alias c='clear'
alias cat="bat"
alias "darwin-switch"="sudo darwin-rebuild switch --flake ~/dotfiles#; source ~/.config/zsh/.zshrc"
alias "darwin-switch-home"="sudo darwin-rebuild switch --flake ~/dotfiles#carbon; source ~/.config/zsh/.zshrc"
alias "darwin-switch-work"="sudo darwin-rebuild switch --flake ~/dotfiles/#neon; source ~/.config/zsh/.zshrc"
alias nix-update="pushd ~/dotfiles; nix --extra-experimental-features 'flakes nix-command' flake update; popd"
alias "nix-switch"="sudo nixos-rebuild switch --flake ~/dotfiles# --impure; source ~/.config/zsh/.zshrc"
alias refresh="source ~/.config/zsh/.zshrc"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

if [ -x "$(command -v fnm)" ]; then
  eval "$(fnm env --use-on-cd --shell zsh)"
  eval "$(fnm completions --shell zsh)"
fi


if [ -x "$(command -v mise)" ]; then
  eval "$(mise activate zsh --shims)"
fi


if [ -x "$(command -v brew)" ]; then
  # Load gcloud completions and path
  test -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" && source "$_"
  test -f "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc" && source "$_"
  
  test -f "$(brew --prefix)/share/gcloud-cli/path.zsh.inc" && source "$_"
  test -f "$(brew --prefix)/share/gcloud-cli/completion.zsh.inc" && source "$_"
fi
