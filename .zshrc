
[[ `who am i` != *\) ]] && is_local=yes

case $TERM in rxvt*) TERM=rxvt esac  # urxvt only, TERM value is not recognized
                                     # when logging on ssh servers

autoload colors; colors  # so we can use $fg / $bg
source /etc/profile  # autojump support
source /usr/share/zsh/plugins/zsh-syntax-highlight/zsh-syntax-highlighting.zsh

# Environment
# ===========

export EDITOR=vim
export PATH=$PATH:~/bin
export PAGER=less
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'



# History
# =======

export HISTSIZE=100000  # huge history size
export SAVEHIST=100000  # save all history when quitting
export HISTFILE=~/.zhistory  # in this file
setopt share_history  # share history between ttys
setopt hist_ignore_all_dups  # do not save a command twice
setopt hist_reduce_blanks  # save the command "echo   plop" as "echo plop"


# Completion
# ==========

autoload compinit; compinit

zstyle ':completion:*' menu yes select  # menu selection
zstyle ':completion:*' format "$fg_bold[grey]%d$reset_color"  # Categories
                                                              # format
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}  # List file colors
zstyle ':completion:*' group-name ''  # Display everything in groups

# Completers list
zstyle ':completion:*' completer _expand _complete _match _approximate

# Completion cache
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# Fuzzy completion
zstyle ':completion:*' matcher-list '+m:{a-z}={A-Z} r:|[._-]=** r:|=**' '' '' \
    '+m:{a-z}={A-Z} r:|[._-]=** r:|=**'
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Do not suggest those users
zstyle -d users
zstyle ':completion:*:*:*:users' ignored-patterns \
    adm apache bin daemon games gdm halt ident junkbust lp mail mailnull \
    named news nfsnobody nobody nscd ntp operator pcap postgres radvd \
    rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs backup  bind  \
    dictd  gnats  identd  irc  man  messagebus  postfix  proxy  sys  www-data \
    avahi Debian-exim hplip list cupsys haldaemon ntpd proftpd statd \
    dbus ftp hal http

# Do not complete CVS directories
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#lost+found' '(*/)#CVS'
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'

# Do not complete already selected arguments
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes

# Nice kill completion
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors \
    '=(#b) #([0-9]#)*=0=01;31'


# Key mapping
# ===========

# To know the corresponding string of a key comination, press ctrl + v then the
# keys. This configuration is for rxvt terminal.

bindkey -e  # emacs style (-v for vi)
# rxvt
# bindkey '^[[7~' beginning-of-line  # origin
# bindkey '^[[8~' end-of-line  # end
# bindkey '^[Od' backward-word  # ctrl + left
# bindkey '^[Oc' forward-word  # ctrl + right
# bindkey '^[[3^' delete-word  # ctrl + del
# bindkey '^[[3~' delete-char  # del
# bindkey '^H' backward-delete-word  # ctrl + backspace == ctrl + h

# Xterm
bindkey '^[[H' beginning-of-line  # origin
bindkey '^[[F' end-of-line  # end
bindkey '^[[1;5D' backward-word  # ctrl + left
bindkey '^[[1;5C' forward-word  # ctrl + right
bindkey '^[[3;5~' delete-word  # ctrl + del
bindkey '^[[3~' delete-char  # del
[ "$TERM" != "linux" ] && bindkey '^?' backward-delete-word  # ctrl + backspace == ctrl + h

# Search history for a command beginning with the current input. It places the
# cursor at the beginning of the command line.
bindkey '^[[A' history-beginning-search-backward  # up
bindkey '^[[B' history-beginning-search-forward  # down

bindkey '^Z' push-input # stash the current input and pop it to the next
                        # command prompt

# Quick ../../..
rationalise-dot() {
    if [[ $LBUFFER = *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}
zle -N rationalise-dot
bindkey '.' rationalise-dot


# Prompt
# ======

autoload -U promptinit; promptinit  # collection of predefined prompts
setopt prompt_subst  # Allow for functions in the prompt.

prompt_alk_setup() {
    PROMPT="%{$fg_bold[blue]%}%~%(40l.
. )%{$fg_no_bold[green]%}%#%{$reset_color%} "

    if [ -z "$is_local" ]; then
        # Remote prompt, prepend user@host
        PROMPT="%{$fg_bold[red]%}%n@%m:$PROMPT"
    fi

    RPROMPT="\$(prompt_git_info) %{$fg[yellow]%}%D{%m-%d %H:%M}%{$reset_color%}"
}

prompt_themes="$prompt_themes alk"  # add our prompt to the collection, so we
                                    # can select it by typing "prompt alk" and
                                    # turning it off with "prompt off"
prompt alk  # load our prompt


# Aliases
# =======

eval `dircolors -b`  # nice colors with ls
alias ls="ls --color=auto"
alias vi=vim
alias v=vim
alias pacman=pacman-color  # install pacman-color from archlinux.fr repo.
                           # To enable autocompletion, edit
                           # /usr/share/zsh/site-functions/_pacman and add
                           # pacman-color to the very first line (#compdef)
alias less='less -R'
alias k=kate
alias diffdists='ls *-dist -1 | sed "s/-dist//" | while read file; do echo "DIFF $file"; diff $file-dist $file; done'
alias psg='ps aux | grep -v grep | grep'

# Confirm file deletion / overright
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'

# End of line aliases
alias -g P='|less'  # paginate
alias -g S='&>/dev/null'  # silent
alias -g CW='--color-words -w -b'

# Open files based on their extension
alias -s png=xv
alias -s jpg=xv
alias -s jpeg=xv



# Other stuffs
# ============

# Print stderr in red // too buggy, can't run sh nor sudo
# exec 2>>(while read line; do
#    print '\e[91m'${(q)line}'\e[0m' > /dev/tty
#    print -n $'\0'
# done &)

# Add every paths accessed by cd to directory stack (pushd / popd). Allows to
# do "cd -1" to go back.
setopt auto_pushd pushd_minus pushd_ignore_dups pushd_silent pushd_to_home \
    auto_cd

setopt no_clobber  # disallow > redirections to an existing file
                   # ( >| to override)

setopt hash_cmds hash_dirs  # command list cache

setopt no_bg_nice  # do not nice bg processes


# xterm title
case $TERM in
    xterm*)
        precmd () {
            if [ -z "$is_local" ]; then
                print -Pn "\e]0;%n@%m: %~\a"
            else
                print -Pn "\e]0; %~\a"
            fi
        }
        ;;
esac

# Print stuff
# ===========

if which fortune &> /dev/null; then
    # fortune-mod-kaamelott from aur
    # other nice fortune (for frenchies): fortune-mod-bashfr
    fortune kaamelott 2> /dev/null || fortune
fi


function superpkill() {

    if [ "$1" = "-f" ]
    then
        force=1
        shift
    else
        force=
    fi

    if [ $# -eq 0 ]
    then
        echo "Usage: superpkill [-f] pattern"
        return 1
    fi

    pids=$(ps x -eo "%p %a" | grep -e "$1" | grep -Ev '^\s*[0-9]+ grep')
    if [ -n "$pids" ]
    then
        echo "$pids"
        if [ -z "$force" ]
        then
            echo "Ok? [Yn]"
            read response
            if [ -n "$response" ] && [ "$response" != "y" ]
            then
                return
            fi
        fi

        kill `echo "$pids" | grep -Eo '^\s*[0-9]+' | tr -d ' '`
    fi
}


# Complete rewrite of olivierverdier git-prompt in pure zsh
# https://github.com/olivierverdier/zsh-git-prompt
# Much faster (no python overhead), and no cache needed as 'git status' has a
# pretty good cache itself
__GIT_AHEAD='↑'
__GIT_BEHIND='↓'
__GIT_STAGED='♦'
__GIT_CHANGED='✚'
__GIT_UNTRACKED='…'
__GIT_CLEAN='✔'
__GIT_UNMERGED='✖'
__GIT_SHA1=':'

function prompt_git_info() {
    staged=0
    unmerged=0
    changed=0
    untracked=0
    branch=""
    remote=""
    while IFS="" read -r line; do
        if [[ $line = (## *) ]]; then
            if [[ $line =~ '^## (([^.\[(]|\.[^.\[(])+)[^\[(]*(\[.*?\])?$' ]]; then
                branch=$match[1]
                d=$match[3]
                [[ $d =~ 'behind ([0-9]+)' ]] &&
                    remote="$remote$__GIT_BEHIND$match[1]"
                [[ $d =~ 'ahead ([0-9]+)'  ]] &&
                    remote="$remote$__GIT_AHEAD$match[1]"
            else
                branch="$__GIT_SHA1`git rev-parse --short HEAD`"
            fi
        elif [[ $line == ((DD|AA|U?|?U) *) ]]; then
            unmerged=$(($unmerged + 1))
        else
            [[ $line == ([^? ]? *) ]] && staged=$(($staged + 1))
            [[ $line == (?[^? ] *) ]] && changed=$(($changed + 1))
            [[ $line == (\?\?\ *)  ]] && untracked=$(($untracked + 1))
        fi
    done < <(git status -s -unormal -b 2> /dev/null)

    [[ -z $branch ]] && return

    printf "%%{${fg[blue]}%%}%s%%{${fg[cyan]}%%}%s%%{$reset_color%%}" "$branch" "$remote"
    if [[ $staged -eq 0 && $unmerged -eq 0 && $changed -eq 0
       && $untracked -eq 0 ]]
    then
        printf "%%{${fg_bold[green]}%%}$__GIT_CLEAN%%{$reset_color%%}"
    else
        [[ $staged -gt 0    ]] &&
            printf "%%{${fg[green]}%%}$__GIT_STAGED%d%%{$reset_color%%}" $staged
        [[ $changed -gt 0   ]] && printf "$__GIT_CHANGED%d" $changed
        [[ $unmerged -gt 0  ]] &&
            printf "%%{${fg[red]}%%}$__GIT_UNMERGED%d%%{$reset_color%%}" $unmerged
        [[ $untracked -gt 0 ]] && printf "$__GIT_UNTRACKED"
    fi
}
