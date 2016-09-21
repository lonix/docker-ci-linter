#!/bin/bash

sudo curl -Lso \
  /usr/bin/shellcheck \
  https://github.com/caarlos0/shellcheck-docker/releases/download/v0.4.4/shellcheck

sudo curl -Lso \
  /usr/bin/hadolint \
  https://github.com/lukasmartinelli/hadolint/releases/download/v1.2.1/hadolint_linux_amd64

sudo chmod +x /usr/bin/shellcheck /usr/bin/hadolint

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo pip install ansible-lint
sudo npm install markdownlint
