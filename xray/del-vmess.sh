#!/bin/bash

clear

BLUE='\033[1;38;5;135m'
GREEN='\033[0;38;5;48m'
RED='\033[0;38;5;203m'
CYAN='\033[0;38;5;51m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "\E[48;5;54;1;38;5;231m            DELETE VMESS ACCOUNT             \E[0m"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${CYAN}📋 List User VMess:${NC}"
echo ""

CONFIG="/etc/xray/config.json"

users=$(jq -r '.inbounds[] | select(.tag=="vmess-tls") | .settings.clients[].email' $CONFIG)

if [[ -z "$users" ]]; then
echo -e "${RED}No VMess users found!${NC}"
read -n 1 -s -r -p "Press any key to return..."
m-vmess
exit
fi

num=1
for user in $users
do
printf "${GREEN}[%s]${NC} %s\n" "$num" "$user"
((num++))
done

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
read -rp "👉 Enter the username to delete: " user
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

jq --arg user "$user" '
(.inbounds[] | select(.tag=="vmess-tls").settings.clients) |=
map(select(.email != $user)) |
(.inbounds[] | select(.tag=="vmess-nontls").settings.clients) |=
map(select(.email != $user))
' $CONFIG > /tmp/config.json

mv /tmp/config.json $CONFIG

# remove expiry comment
sed -i "/#vmess $user/d" $CONFIG

systemctl restart xray

echo ""
echo -e "${GREEN}✅ VMess user '${user}' deleted successfully!${NC}"
echo ""

read -n 1 -s -r -p "Press any key to return to the menu..."

m-vmess
