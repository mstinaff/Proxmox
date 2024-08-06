#!/usr/bin/env bash

# Copyright (c) 2024 Mstinaff
# Author: Mstinaff
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
msg_ok "Installed Dependencies"

msg_info "Installing Vikunja"
LATEST=$(curl -sL https://dl.vikunja.io/vikunja | grep -Po '(?<="name">)(.*)(?=<)' | sort -rn | head -n 1)
msg_info "vikunja_${LATEST}_amd64.deb"
#wget https://dl.vikunja.io/vikunja/${LATEST}/vikunja-${LATEST}-amd64.deb &>/dev/null
wget https://dl.vikunja.io/vikunja/0.24.1/vikunja-0.24.1-amd64.deb
$STD dpkg -i vikunja_${LATEST}_amd64.deb &>/dev/null
rm vikunja_${LATEST}_amd64.deb
msg_ok "Installed Vikunja"

msg_info "Enabliong Service"
systemctl enable -q --now Vikunja.service
msg_ok "Service Enabled"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
