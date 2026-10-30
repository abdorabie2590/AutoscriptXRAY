#!/bin/bash
# Speedtest CLI - by Eng.Abdelrahman Rabie

# Colors
GREEN='\e[1;38;5;48m'
CYAN='\e[1;38;5;51m'
YELLOW='\e[1;38;5;220m'
NC='\e[0m'

clear
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}              🌐 SPEEDTEST VPS                ${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check whether speedtest-cli is installed
if ! command -v speedtest &> /dev/null; then
    echo -e "${YELLOW}⚠️ speedtest-cli is not installed... installing...${NC}"
    apt-get update -y >/dev/null 2>&1
    apt-get install speedtest-cli -y >/dev/null 2>&1
fi

# Run speedtest
echo -e "${CYAN}Testing connection... Please wait...${NC}"
speedtest --simple

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✔️ Done${NC}"
