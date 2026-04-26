# ── History ────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS       # Don't record duplicate commands
setopt HIST_IGNORE_SPACE      # Don't record commands starting with space
setopt SHARE_HISTORY          # Share history across sessions
setopt HIST_VERIFY            # Show expanded history before executing

# ── Completion ─────────────────────────────────────────────
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select          # Arrow-key navigable menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case insensitive
zstyle ':completion:*' list-colors ''       # Colored completions
zstyle ':completion:*:*:kill:*' menu yes    # Better kill completion

# ── Key Bindings ───────────────────────────────────────────
bindkey -e                                  # Emacs keys (Ctrl+A, Ctrl+E etc)
bindkey '^[[A' history-search-backward   # Up arrow - search history
bindkey '^[[B' history-search-forward    # Down arrow - search history
bindkey '^ ' autosuggest-accept          # Ctrl+Space - accept suggestion

# ── Options ────────────────────────────────────────────────
setopt AUTO_CD                # cd by typing directory name
setopt CORRECT                # Suggest corrections for typos
setopt GLOB_DOTS              # Include dotfiles in globs
setopt EXTENDED_GLOB          # Extended globbing (^, #, ~ patterns)

# ── Aliases ────────────────────────────────────────────────
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias ll='ls -lh --color=auto'
alias la='ls -alh --color=auto'
alias lt='ls -ltrh --color=auto'
alias rmt='rm *~'
alias emax='emacs --maximized'
alias em='emacs -nw'

# Git
alias gs='git status'
alias gl='git log --oneline --graph --decorate -20'
alias gd='git diff'

# Development
alias cmk='cmake -DCMAKE_BUILD_TYPE=Release'
alias cmkd='cmake -DCMAKE_BUILD_TYPE=Debug'

# ── Plugins ────────────────────────────────────────────────
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Autosuggestion style - dim gray
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
# Accept suggestion with Ctrl+Space
bindkey '^ ' autosuggest-accept

# ── Prompt ─────────────────────────────────────────────────
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
else
  # Fallback: pure zsh prompt (no external dependencies)
  autoload -Uz vcs_info
  autoload -Uz add-zsh-hook

  add-zsh-hook precmd vcs_info

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr '%F{green}●%f'
  zstyle ':vcs_info:git:*' unstagedstr '%F{yellow}●%f'
  zstyle ':vcs_info:git:*' formats ' %F{cyan}(%b)%f %c%u'
  zstyle ':vcs_info:git:*' actionformats ' %F{cyan}(%b|%a)%f %c%u'

  setopt PROMPT_SUBST

  PROMPT='%F{blue}%n@%m%f %F{yellow}%3~%f${vcs_info_msg_0_} 
  %(?.%F{green}.%F{red})❯%f '
  RPROMPT='%(?.·.%F{red}✘ %?%f) %F{240}%T%f'
fi

# ── Environment Modules ────────────────────────────────────
# Source modules init if not already loaded
if ! command -v module &>/dev/null; then
    if [[ -f /usr/share/modules/init/zsh ]]; then
        source /usr/share/modules/init/zsh
    elif [[ -f /usr/local/Modules/init/zsh ]]; then
        source /usr/local/Modules/init/zsh
    fi
fi


export EDITOR=emacs

# Local overrides
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local