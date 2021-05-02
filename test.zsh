#!/usr/bin/env zsh

result=0

check() {
  if (type $1 &>/dev/null); then
    echo -e "\e[32m[PASSED]\e[m $1 "
    return 0
  else
    echo -e "\e[31m[FAILED]\e[m $1 "
    result=1
    return 1
  fi
}

# test built-in commands
check "cd"
check "ls"
check "pwd"
check "cp"
check "mv"

# test brew packages
check "python"
check "perl"
check "ruby"
check "go"
check "fd"
check "rg"

# test aliases
check "e"
check "relogin"
check "re"
check "d"
check "py"
check "brew"
check "sum"

# test installed tools
check "zinit"
check "pipenv"
check "poetry"

# test user functions
check "les"
check "bm"
check "mkcd"
check "pss"

exit $result
