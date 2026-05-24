
function prompt_jj_info_enabled() {
    jj log --revisions @ --no-graph --ignore-working-copy --limit 1 >& /dev/null
}

function prompt_jj_info() {
    local jjlog=(jj log --no-graph --ignore-working-copy -r)

    local change_id=$($jjlog @ --template 'change_id.shortest(4)')
    echo -n "%{$fg[cyan]%}$change_id%{$reset_color%}"

    local current_bookmark=$($jjlog @ --template bookmarks)
    if [[ -n $current_bookmark ]]; then
        echo -n " %{$fg[magenta]%}→%{$reset_color%}$current_bookmark"
    else
        local next_bookmark=$($jjlog 'roots(@:: & bookmarks())' --template bookmarks)
        if [[ -n $next_bookmark ]]; then
            local distance=$(( $($jjlog '@::roots(@:: & bookmarks())' --template '"\n"' | wc -l) - 1 ))
            echo -n " %{$fg[magenta]%}$distance↓%{$reset_color%}$next_bookmark"
        else
            local prev_bookmark=$($jjlog 'heads(::@ & bookmarks())' --template bookmarks)
            if [[ -n $prev_bookmark ]]; then
                local distance=$(( $($jjlog 'heads(::@ & bookmarks())::@' --template '"\n"' | wc -l) - 1 ))
                echo -n " %{$fg[magenta]%}$distance↑%{$reset_color%}$prev_bookmark"
            fi
        fi
    fi

    local files=$($jjlog @ --template 'diff.files().len()')
    echo -n " %{$fg[yellow]%}♦$files%{$reset_color%}"

    local conflicts=$($jjlog @ --template '
        if (
            conflict,
            diff.files().filter(|file| file.target().conflict()).len(),
        )
    ')

    if [[ -n $conflicts ]]; then
        echo -n "%{$fg[red]%}✖$conflicts%{$reset_color%}"
    fi
}
