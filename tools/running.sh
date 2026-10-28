#!/bin/bash
# Submenu Status Service - by Eng.Abdelrahman Rabie

# Warna
NC='\e[0m'
GREEN='\e[1;38;5;48m'
YELLOW='\e[1;38;5;220m'
CYAN='\e[1;38;5;51m'

clear
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}          📡 STATUS LAYANAN AKTIF           ${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Cek status layanan utama
services=(
  "ssh"
  "dropbear"
  "sshws"
  "xray"
  "stunnel4"
  "wg-quick@wg0"
)

for svc in "${services[@]}"; do
  status=$(systemctl is-active $svc 2>/dev/null)
  printf "%-15s : %s\n" "$svc" "${status^^}"
done

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
read -n1 -r -p "⏎ Tekan enter untuk kembali ke menu utama..."
menu
