#!/bin/bash


success() {
  printf "\r  [ \033[00;32mOK\033[0m ] Linting %s...\n" "$1"
}

fail() {
  printf "\r  [\033[0;31mFAIL\033[0m] Linting %s...\n" "$1"
  exit 1
}

info() {
  printf "\r  [ \033[00;34m??\033[0m ] %s\n" "$1"
}

check_shell() {
  local script="$1"
  shellcheck "$script" || fail "$script"
  success "$script"
}

check_docker() {
  local script="$1"
  hadolint "$script" || fail "$script"
  success "$script"
}

check_ansible() {
  local script="$1"
  ansible-lint "$script" || fail "$script"
  success "$script"
}

file_list() {
	 git ls-tree -r HEAD | awk '{print $4}'
}

file_list | while read -r script; do
	if [[ $script == "Dockerfile" ]]; then
		check_docker "$script"
	elif [[ $script  == *.sh ]]; then
		check_shell "$script"
	elif [[ $script == *.yml ]]; then
		check_ansible "$script"
	else
		info "Skipping $script..."
	fi
done
