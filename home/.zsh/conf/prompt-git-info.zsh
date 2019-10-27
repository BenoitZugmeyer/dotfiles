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

function prompt_git_info_mode() {
    if [[ -e $(git rev-parse --git-dir)/$2 ]]; then
        printf "($1)"
    fi
}

function prompt_git_info() {
    local staged=0
    local unmerged=0
    local changed=0
    local untracked=0
    local branch=""
    local remote=""

    while IFS="" read -r line; do
        if [[ $line = (## *) ]]; then
            if [[ $line =~ '^## (([^.\[(]|\.[^.\[(])+)[^\[(]*(\[.*\])?$' ]]; then
                branch=$match[1]
                local d=$match[3]
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

    prompt_git_info_mode cherry-pick sequencer/todo
    prompt_git_info_mode rebase      rebase-merge/git-rebase-todo
    prompt_git_info_mode merge       MERGE_HEAD
    prompt_git_info_mode bisect      BISECT_START
}
