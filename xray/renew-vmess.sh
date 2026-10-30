#!/bin/bash

clear

BLUE='\033[1;38;5;135m'
GREEN='\033[0;38;5;48m'
CYAN='\033[0;38;5;51m'
RED='\033[0;38;5;203m'
NC='\033[0m'

CONFIG="/etc/xray/config.json"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "\E[48;5;54;1;38;5;231m            RENEW VMESS ACCOUNT            \E[0m"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${CYAN}📋 VMess User List:${NC}"
echo ""

users=$(jq -r '.inbounds[] | select(.tag=="vmess-tls") | .settings.clients[].email' $CONFIG)

for user in $users
do
echo -e " - ${GREEN}$user${NC}"
done

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

read -rp "Enter the username to renew: " user

if ! echo "$users" | grep -w "$user" >/dev/null; then
echo -e "${RED}User not found!${NC}"
sleep 2
m-vmess
exit
fi

read -rp "Add validity (days): " validity_days

exp=$(date -d "$validity_days days" +"%Y-%m-%d")

# update expire comment
sed -i "s/^#vmess $user .*/#vmess $user $exp/g" /etc/xray/config.json

systemctl restart xray

clear
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "\E[48;5;54;1;38;5;231m            ACCOUNT RENEWED SUCCESSFULLY       \E[0m"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "User      : ${GREEN}$user${NC}"
echo -e "Expired   : ${GREEN}$exp${NC}"
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

read -n 1 -s -r -p "Press any key to return..."

m-vmess
