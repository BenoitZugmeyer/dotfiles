prompt_alk_setup() {
    PROMPT="%{$fg_bold[blue]%}%~%(40l.
. )%{$fg_no_bold[green]%}%#%{$reset_color%} "

    if [[ -n "$SSH_CONNECTION" ]]; then
        # Remote prompt, prepend user@host
        PROMPT="%{$fg_bold[red]%}%n@%m:$PROMPT"
    fi

    RPROMPT="\$(prompt_alk_vcs_info)"
}

prompt_alk_vcs_info() {
    if prompt_jj_info_enabled; then
        prompt_jj_info
    else
        prompt_git_info
    fi
}

prompt_themes="$prompt_themes alk"  # add our prompt to the collection, so we
                                    # can select it by typing "prompt alk" and
                                    # turning it off with "prompt off"
prompt alk  # load our prompt
