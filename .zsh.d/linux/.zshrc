PROMPT="[%F{green}%m%f-%F{yellow}(%~)%f]
$ "

# direnv (after setting PROMPT)
show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
    echo "($(basename ${DIRENV_DIR:1}))"
  fi
}
PROMPT='$(show_virtual_env)'$PROMPT
