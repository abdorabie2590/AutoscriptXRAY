#!/bin/bash
# Delete SS WS account - by Eng.Abdelrahman Rabie

read -p "Enter the username to delete: " user
config=/etc/xray/config.json

if grep -q "### $user" "$config"; then
    sed -i "/### $user/,/},/d" "$config"
    systemctl restart xray
    echo -e "\n✅ Account '$user' deleted from SS WS"
else
    echo -e "\n❌ Account '$user' not found!"
fi
