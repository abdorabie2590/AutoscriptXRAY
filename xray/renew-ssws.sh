#!/bin/bash
# Renew SS WS account - by Eng.Abdelrahman Rabie

read -p "Enter the username to renew: " user
read -p "Add validity (days): " add_days

exp_now=$(grep -w "### $user" /etc/xray/config.json | cut -d ' ' -f3)
if [[ -z "$exp_now" ]]; then
    echo "❌ Username not found!"
    exit 1
fi

exp_ts=$(date -d "$exp_now" +%s)
now_ts=$(date +%s)
remain_days=$(( (exp_ts - now_ts) / 86400 ))
total_days=$(( remain_days + add_days ))
new_exp=$(date -d "$total_days days" +%Y-%m-%d)

sed -i "s/### $user.*/### $user $new_exp/" /etc/xray/config.json
systemctl restart xray

echo -e "\n✅ Account '$user' renewed until $new_exp"
