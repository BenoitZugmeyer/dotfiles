autoload -Uz promptinit && promptinit
autoload -U compinit && compinit
autoload -U colors && colors

# env
export EDITOR=nvim
export PATH=$PATH:~/.bin:~/.composer/vendor/bin:~/.cargo/bin:~/.npm/bin
export PAGER=less
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

export HISTSIZE=100000  # huge history size
export SAVEHIST=100000  # save all history when quitting
export HISTFILE=~/.zhistory

# options
setopt APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt DVORAK
setopt MENU_COMPLETE
setopt PROMPT_SUBST
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt NO_CLOBBER


# keys
bindkey -e
bindkey "^[[A" history-beginning-search-backward # up
bindkey "^[[B" history-beginning-search-forward  # down
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[^[[C" forward-word
bindkey "^[^[[D" backward-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

bindkey '^Z' push-input # stash the current input and pop it to the next
                        # command prompt

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^e' edit-command-line

# completions
if which dircolors > /dev/null; then
  eval $(dircolors)
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  alias ls='ls --color'
else
  export CLICOLOR=YES
  zstyle ':completion:*:default' list-colors ''
fi
zstyle ':completion:*' menu yes select
zstyle ':completion:*' format "$fg_bold[grey]%d$reset_color"
zstyle ':completion:*' group-name ''  # Display everything in groups

# Completers list
zstyle ':completion:*' completer _expand _complete _match _approximate

# Fuzzy completion
zstyle ':completion:*' matcher-list '+m:{a-z}={A-Z} r:|[._-]=** r:|=**' '' '' \
    '+m:{a-z}={A-Z} r:|[._-]=** r:|=**'
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Do not complete already selected arguments
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes


# aliases
alias :e=nvim
alias vim=nvim
alias psg='ps aux | grep -v grep | grep'
alias scu='systemctl --user'
alias xcopy="xclip -selection clipboard"
alias xpaste="xclip -o -selection clipboard"
alias torrent='ssh -t crocus screen -x torrent/'
alias rm-vim-tmp-files='find ~/.vim/tmp/ ~/.vim/view/ ~/.local/share/nvim/view ~/.local/share/nvim/swap -type f -delete'


# end of line aliases
alias -g P='|less'  # paginate
alias -g S='&>/dev/null'  # silent
alias -g CW='--color-words -w -b'
alias -g L='|& less -S'

# fasd
eval "$(fasd --init auto)" # fasd
alias j=z
unalias f  # f is aliased to 'fasd -f', and conflicts with our f function

# fzf
# same as default fzf command, except it lists dot files
export FZF_DEFAULT_COMMAND='command find -L .       \
    -mindepth 1                                     \
    \(                                              \
        -path "*/\.git/*" -o                        \
        -fstype "sysfs" -o                          \
        -fstype "devfs" -o                          \
        -fstype "devtmpfs" -o                       \
        -fstype "proc"                              \
    \) -prune -o                                    \
    -type f -print -o                               \
    -type l -print 2> /dev/null | cut -b3-'



function source_if_exists () {
  if [[ -e "$1" ]]; then
    source "$1"
  fi
}

# Arch Linux
source_if_exists /etc/profile.d/depot_tools.sh
source_if_exists /usr/share/doc/pkgfile/command-not-found.zsh
source_if_exists /usr/share/fzf/completion.zsh
source_if_exists /usr/share/fzf/key-bindings.zsh
source_if_exists /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Mac OS
source_if_exists /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

unset source_if_exists

function load () {
  source "$HOME/.zsh/conf/$1.zsh"
}

load npm-path
load prompt-alk
load prompt-git-info
load f
load fzf-extra
load manydots-magic

unset load
