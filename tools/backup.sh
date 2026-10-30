#!/bin/bash
# Backup tool - by Eng.Abdelrahman Rabie

# Colors
GREEN='\e[1;38;5;48m'
YELLOW='\e[1;38;5;220m'
CYAN='\e[1;38;5;51m'
NC='\e[0m'

clear
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}            🔄 BACKUP & RESTORE TOOLS         ${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}[1]${NC} Backup Data"
echo -e "${GREEN}[2]${NC} Restore Data"
echo -e "${GREEN}[x]${NC} Back to menu"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
read -p "👉 Select option: " opt

backup_folder="/root/backup-autoscript"
mkdir -p "$backup_folder"

case $opt in
1)
  echo -e "\n📦 Creating backup..."
  cp -r /etc/xray/config.json $backup_folder/ 2>/dev/null
  cp -r /etc/xray/domain $backup_folder/ 2>/dev/null
  cp -r /usr/bin/* $backup_folder/ 2>/dev/null

  cd /root
  zip -r backup-autoscript.zip backup-autoscript >/dev/null
  echo -e "\n✅ Backup completed!"
  echo -e "📁 File: /root/backup-autoscript.zip"
  echo -e "${YELLOW}Keep this zip file for restoring later.${NC}"
  ;;
2)
  read -p "🗂 Enter the path of the backup ZIP file: " path
  if [[ -f "$path" ]]; then
    echo -e "\n🔄 Restore data..."
    unzip "$path" -d /root >/dev/null
    cp -r /root/backup-autoscript/config.json /etc/xray/
    cp -r /root/backup-autoscript/domain /etc/xray/
    cp -r /root/backup-autoscript/* /usr/bin/
    systemctl restart xray
    echo -e "\n✅ Restore completed!"
  else
    echo -e "❌ Backup file not found!"
  fi
  ;;
x) menu ;;
*) echo "❌ Invalid option!" ; sleep 1 ; bash $0 ;;
esac
