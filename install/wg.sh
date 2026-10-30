#!/bin/bash
# Install WireGuard + initial configuration
# By Eng.Abdelrahman Rabie

GREEN='\033[0;38;5;48m'
NC='\033[0m'

echo -e "${GREEN}▶️ Starting WireGuard installation...${NC}"

# Install dependencies
apt update -y

apt install -y \
    wireguard \
    wireguard-tools \
    qrencode \
    resolvconf

# Create config directory
mkdir -p /etc/wireguard
cd /etc/wireguard || exit

# Generate key
privkey=$(wg genkey)
pubkey=$(echo "$privkey" | wg pubkey)

# Save private and public keys
echo "$privkey" > private.key
echo "$pubkey" > public.key
chmod 600 private.key
chmod 644 public.key

# Get default interface (eth0/fallback)
interface=$(ip route | grep default | awk '{print $5}' | head -n1)

if [[ -z "$interface" ]]; then
    echo "[ERROR] Failed to detect network interface!"
    exit 1
fi
# Create wg0.conf configuration
cat > wg0.conf <<EOF
[Interface]
Address = 10.66.66.1/24
ListenPort = 51820
PrivateKey = $privkey
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o $interface -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o $interface -j MASQUERADE
SaveConfig = true
EOF

# Enable IP forwarding
cat > /etc/sysctl.d/30-wg.conf <<EOF
net.ipv4.ip_forward=1
EOF

sysctl --system >/dev/null 2>&1

# === TESTING AGAIN

wg-quick strip wg0 >/dev/null 2>&1 || {
    echo "[ERROR] Invalid WireGuard configuration!"
    exit 1
}

# Enable and start service

systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0

sleep 2

systemctl is-active --quiet wg-quick@wg0 || {
    echo "[ERROR] WireGuard failed to start!"
    journalctl -u wg-quick@wg0 -n 20 --no-pager
    exit 1
}
# Append to /root/log-install.txt
touch /root/log-install.txt
grep -q "WireGuard" /root/log-install.txt || \
echo "WireGuard        : 51820" >> /root/log-install.txt

echo -e "${GREEN}✅ WireGuard installed and active on port 51820!${NC}"
