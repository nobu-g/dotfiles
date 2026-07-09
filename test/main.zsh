#!/usr/bin/env zsh

result=0

_report() {
  # _report <name> <status>  (status 0 = passed)
  if [[ $2 -eq 0 ]]; then
    echo -e "\e[32m[PASSED]\e[m $1 "
    return 0
  else
    echo -e "\e[31m[FAILED]\e[m $1 "
    result=1
    return 1
  fi
}

check() {
  type "$1" &> /dev/null
  _report "$1" $?
}

check_alias() {
  [[ "$(whence -w "$1")" == *": alias" ]]
  _report "$1" $?
}
printenv
brew doctor

# test shell built-in commands
check "alias"
check "autoload"
check "bindkey"
check "cd"
check "echo"
check "export"
check "history"
check "setopt"
check "source"
check "unsetopt"

# test pre-installed commands
check "cat"
check "chmod"
check "cp"
check "grep"
check "ls"
check "man"
check "mv"
check "pwd"
check "rm"

# test brew packages
check "fd"
check "fzf"
check "git"
check "go"
check "perl"
check "python3"
check "rg"
check "ruby"

# test aliases
check_alias "a"
check_alias "d"
check_alias "e"
check_alias "g"
check_alias "relogin"
check_alias "re"
check_alias "p"
check_alias "py"
check_alias "brew"
check_alias "sum"

# test installed tools
check "zinit"
check "virtualenv"
check "ruff"
check "pre-commit"
check "uv"

# test user functions
check "les"
check "bm"
check "mkcd"
check "pss"

exit $result
