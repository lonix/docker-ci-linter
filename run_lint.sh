#!/bin/bash
unset FAIL

success() {
  printf "\r  [ \033[00;32mOK\033[0m ] Linting %s...\n" "$1"
}

fail() {
  printf "\r  [\033[0;31mFAIL\033[0m] Linting %s...\n" "$1"
}

info() {
  printf "\r  [ \033[00;34m??\033[0m ] %s\n" "$1"
}

check_bash() {
  local script="$1"

  if ! shellcheck "$script"; then
    fail "$script"
    export FAIL=true
  else
    success "$script"
  fi
}

check_docker() {
  local script="$1"

  if ! hadolint "$script"; then
    fail "$script"
    export FAIL=true
  else
    success "$script"
  fi
}

check_ansible() {
  local script="$1"

  if ! ansible-lint "$script"; then
    fail "$script"
    export FAIL=true
  else
    success "$script"
  fi
}

check_markdown() {
  local script="$1"

  if ! markdownlint "$script"; then
    fail "$script"
    export FAIL=true
  else
    success "$script"
  fi
}

file_list() {
     git ls-tree -r HEAD | awk '{print $4}'
}

  file_list | while read -r script; do
      if [[ $script == *Dockerfile ]]; then
          check_docker "$script"
      elif [[ $script == *.MD || $script == *.md ]]; then
          check_markdown "$script"
      elif [[ $script  == *.sh ]]; then
          check_bash "$script"
      elif [[ $script == *.yml ]]; then
          check_ansible "$script"
      else
          info "Skipping $script..."
      fi
  done

  if [ $FAIL == true ] ; then
    error "Linting failed"
    exit 1
  else
    info "All Linting tests OK"
    exit 0
  fi
