#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/mstinaff/Proxmox/main/misc/build.func)
# Copyright (c) 2024 Mstinaff
# Author: Mstinaff
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
 _    ___ __                 _      
| |  / (_) /____  ______    (_)___ _
| | / / / //_/ / / / __ \  / / __ `/
| |/ / / ,< / /_/ / / / / / / /_/ / 
|___/_/_/|_|\__,_/_/ /_/_/ /\__,_/  
                      /___/                                  
 
EOF
}
header_info
echo -e "Loading..."
APP="Vikunja"
var_disk="8"
var_cpu="1"
var_ram="1024"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[ ! -d /opt/vikunja ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
if (( $(df /boot | awk 'NR==2{gsub("%","",$5); print $5}') > 80 )); then
  read -r -p "Warning: Storage is dangerously low, continue anyway? <y/N> " prompt
  [[ ${prompt,,} =~ ^(y|yes)$ ]] || exit
fi

msg_info "Stopping ${APP}"
systemctl stop vikunja
msg_ok "Stopped ${APP}"

msg_info "Updating ${APP}"
LATEST=$(curl -sL https://dl.vikunja.io/vikunja | grep -Po '(?<="name">)(.*)(?=<)' | sort -rn | head -n 1)
wget https://dl.vikunja.io/vikunja/${LATEST}/vikunja-${LATEST}-amd64.deb &>/dev/null
#wget https://dl.vikunja.io/vikunja/0.24.1/vikunja-0.24.1-amd64.deb
dpkg -i vikunja-${LATEST}-amd64.deb &>/dev/null
rm vikunja-${LATEST}-amd64.deb
msg_ok "Updated ${APP}"


msg_info "Starting ${APP}"
systemctl start vikunja
msg_ok "Started ${APP}"
msg_ok "Updated Successfully"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} Setup should be reachable by going to the following URL.
         ${BL}http://${IP}:3456${CL} \n"
