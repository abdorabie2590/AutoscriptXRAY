#!/bin/bash
# Delete WireGuard account - by Eng.Abdelrahman Rabie

read -p "Enter the username to delete: " user
pubkey=$(grep -A 3 "# $user" /etc/wireguard/wg0.conf | grep PublicKey | awk '{print $3}')

if [[ -z "$pubkey" ]]; then
  echo "❌ User not found!"
  exit 1
fi

# Remove from config
sed -i "/# $user/,+4d" /etc/wireguard/wg0.conf
rm -f /etc/wireguard/clients/$user.conf

systemctl restart wg-quick@wg0
echo -e "\n✅ WireGuard account '$user' deleted successfully!"
