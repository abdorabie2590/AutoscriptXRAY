#!/bin/bash
# Atur ulang domain - by Eng.Abdelrahman Rabie

# Warna
CYAN='\e[1;38;5;51m'
GREEN='\e[1;38;5;48m'
YELLOW='\e[1;38;5;220m'
NC='\e[0m'

clear
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}              🌐 GANTI DOMAIN XRAY            ${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Minta domain baru
read -rp "📌 Masukkan domain baru: " new_domain

# Validasi input
if [[ -z "$new_domain" ]]; then
    echo -e "${YELLOW}❌ Domain tidak boleh kosong!${NC}"
    exit 1
fi

# Simpan domain baru ke file
echo "$new_domain" > /etc/xray/domain

# Restart service
systemctl restart xray

# Output
echo -e "${GREEN}✅ Domain berhasil diganti!${NC}"
echo -e "🌐 Domain baru: ${CYAN}$new_domain${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
