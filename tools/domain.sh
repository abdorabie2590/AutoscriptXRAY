#!/bin/bash
# Reset domain - by Eng.Abdelrahman Rabie

# Colors
CYAN='\e[1;38;5;51m'
GREEN='\e[1;38;5;48m'
YELLOW='\e[1;38;5;220m'
NC='\e[0m'

clear
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}              🌐 CHANGE XRAY DOMAIN            ${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Ask for new domain
read -rp "📌 Enter the new domain: " new_domain

# Validate input
if [[ -z "$new_domain" ]]; then
    echo -e "${YELLOW}❌ Domain must not be empty!${NC}"
    exit 1
fi

# Save new domain to file
echo "$new_domain" > /etc/xray/domain

# Restart service
systemctl restart xray

# Output
echo -e "${GREEN}✅ Domain changed successfully!${NC}"
echo -e "🌐 New domain: ${CYAN}$new_domain${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
