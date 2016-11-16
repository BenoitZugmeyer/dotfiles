
# env
export EDITOR=vim
export PATH=$PATH:~/bin:~/.gem/ruby/2.1.0/bin:~/.composer/vendor/bin:~/.cargo/bin
export PAGER=less
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

export HISTSIZE=100000  # huge history size
export SAVEHIST=100000  # save all history when quitting
setopt hist_reduce_blanks  # save the command "echo   plop" as "echo plop"

zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
unsetopt extendedglob

# keys
bindkey "\eOA" history-beginning-search-backward # up
bindkey "\eOB" history-beginning-search-forward  # down

bindkey '^Z' push-input # stash the current input and pop it to the next
                        # command prompt

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^e' edit-command-line

# aliases
alias :e=vim
alias psg='ps aux | grep -v grep | grep'
alias scu='systemctl --user'
alias xcopy="xclip -selection clipboard"
alias xpaste="xclip -o -selection clipboard"

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
source /etc/profile.d/fzf.zsh

function load () {
    source "$HOME/.zsh/conf/$1.zsh"
}

load npm-path
load prompt-alk
load prompt-git-info
load f
load fzf-extra

unset load
