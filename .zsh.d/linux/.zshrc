PROMPT="[%F{green}%m%f-%F{yellow}(%~)%f]
$ "


# use cached directory for virtualenv
export WORKON_HOME=/mnt/berry_f/home/ueda/.virtualenvs

# direnv (after setting PROMPT)
# eval "$(direnv hook zsh)"
show_virtual_env() {
    if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
        echo "($(basename ${DIRENV_DIR:1}))"
    fi
}
PROMPT='$(show_virtual_env)'$PROMPT
