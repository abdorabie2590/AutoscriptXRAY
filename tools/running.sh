#!/bin/bash
# Service status submenu - by Eng.Abdelrahman Rabie

# Colors
NC='\e[0m'
GREEN='\e[1;38;5;48m'
YELLOW='\e[1;38;5;220m'
CYAN='\e[1;38;5;51m'

clear
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}          📡 ACTIVE SERVICES STATUS           ${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check main service status
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
read -n1 -r -p "⏎ Press enter to return to the main menu..."
menu
