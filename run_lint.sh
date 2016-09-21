#!/bin/bash

failure_count=0

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
    (( failure_count++ ))
  else
    success "$script"
  fi
}

check_docker() {
  local script="$1"

  if ! hadolint "$script"; then
    fail "$script"
    (( failure_count++ ))
  else
    success "$script"
  fi
}

check_ansible() {
  local script="$1"

  if ! ansible-lint "$script"; then
    fail "$script"
    (( failure_count++ ))
  else
    success "$script"
  fi
}

check_markdown() {
  local script="$1"

  if ! markdownlint "$script"; then
    fail "$script"
    (( failure_count++ ))
  else
    success "$script"
  fi
}

file_list() {
     git ls-tree -r HEAD | awk '{print $4}'
}

if [ $SHLVL -gt 1 ]; then
  file_list | while read -r script; do
      if [[ $script == *Dockerfile ]]; then
          check_docker "$script"
    elif [[ $script == *.MD ]]; then
      check_markdown "$script"
      elif [[ $script  == *.sh ]]; then
          check_bash "$script"
      elif [[ $script == *.yml ]]; then
          check_ansible "$script"
      else
          info "Skipping $script..."
      fi
  done

  if [[ $failure_count -eq 0 ]]; then
    info "All tests ok"
    exit 0
  else
    error "$failure_count failed linting"
    exit 1
  fi
fi
