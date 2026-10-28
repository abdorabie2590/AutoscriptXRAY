#!/bin/bash

# ABDELRAHMAN RABIE XRAY PANEL
# Developed by Eng.Abdelrahman Rabie

# ================= COLOR =================
PANEL_VERSION="v3.0.0"

# ================= THEME =================
for _t in /etc/autoscriptvpn/theme.sh /root/AutoscriptXRAY/theme.sh; do
    [[ -f "$_t" ]] && { source "$_t"; break; }
done

RED='\033[1;38;5;203m'
GREEN='\033[1;38;5;48m'
YELLOW='\033[1;38;5;220m'
BLUE='\033[1;38;5;99m'
CYAN='\033[1;38;5;51m'
WHITE='\033[1;38;5;231m'
NC='\033[0m'

CONFIG="/etc/xray/config.json"
LOG="/var/log/xray/access.log"

# ================= ANIMATION =================

loading() {
local text="$1"

echo -ne "${CYAN}➜ ${text}${NC}"

for i in {1..3}; do
    echo -ne "."
    sleep 0.35
done

echo ""


}

type_text() {
    local delay="${2:-0.02}"

    while IFS= read -r -n1 char; do
        printf "%s" "$char"
        sleep "$delay"
    done

    echo
}

# ================= SYSTEM INFO =================

IP=$(curl -s ipv4.icanhazip.com)
DOMAIN=$(cat /etc/xray/domain 2>/dev/null || echo "N/A")

ISP=$(curl -s --max-time 3 ipinfo.io/org | cut -d " " -f2-)
[[ -z "$ISP" ]] && ISP="Unknown"

UPTIME=$(uptime -p | sed 's/up //')
TIME=$(date "+%d-%m-%Y %H:%M:%S")

OS=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2+$4"%"}')

RAM=$(free -m | awk 'NR==2{printf "%sMB / %sMB",$3,$2}')

DISK=$(df -h / | awk 'NR==2{print $3 "/" $2}')

# ================= NETWORK =================

IFACE=$(ip route get 1.1.1.1 | awk '{print $5; exit}')

MONTH_NAME=$(date +"%Y-%m")

TODAY=$(vnstat -i $IFACE | awk '/today/ {print $8" "$9}')

YESTERDAY=$(vnstat -i $IFACE | awk '/yesterday/ {print $8" "$9}')

MONTH=$(vnstat -i $IFACE | awk -v m="$MONTH_NAME" '
$1 ~ m {print $8" "$9}
')

TOTAL_BW=$(vnstat --oneline | cut -d; -f15)

[[ -z "$YESTERDAY" ]] && YESTERDAY="0 B"
[[ -z "$TOTAL_BW" ]] && TOTAL_BW="0 B"

# ================= STATUS =================

XRAY=$(systemctl is-active xray)

if [[ $XRAY == "active" ]]; then
XRAY="${GREEN}🟢 ONLINE${NC}"
else
XRAY="${RED}🔴 OFFLINE${NC}"
fi

NGINX=$(systemctl is-active nginx)

if [[ $NGINX == "active" ]]; then
NGINX="${GREEN}🟢 ONLINE${NC}"
else
NGINX="${RED}🔴 OFFLINE${NC}"
fi

WG=$(systemctl is-active wg-quick@wg0)

if [[ $WG == "active" ]]; then
WG="${GREEN}🟢 ONLINE${NC}"
else
WG="${RED}🔴 OFFLINE${NC}"
fi

ZIVPN=$(systemctl is-active zivpn)

if [[ $ZIVPN == "active" ]]; then
ZIVPN="${GREEN}🟢 ONLINE${NC}"
else
ZIVPN="${RED}🔴 OFFLINE${NC}"
fi

UDPCUSTOM=$(systemctl is-active udp-custom)

if [[ $UDPCUSTOM == "active" ]]; then
    UDPCUSTOM="${GREEN}🟢 ONLINE${NC}"
else
    UDPCUSTOM="${RED}🔴 OFFLINE${NC}"
fi

DROPBEARWS=$(systemctl is-active dropbear-ws)

if [[ $DROPBEARWS == "active" ]]; then
DROPBEARWS="${GREEN}🟢 ONLINE${NC}"
else
DROPBEARWS="${RED}🔴 OFFLINE${NC}"
fi

STUNNELWS=$(systemctl is-active stunnel-ws)

if [[ $STUNNELWS == "active" ]]; then
    STUNNELWS="${GREEN}🟢 ONLINE${NC}"
else
    STUNNELWS="${RED}🔴 OFFLINE${NC}"
fi

DROPBEAR=$(systemctl is-active dropbear)

if [[ $DROPBEAR == "active" ]]; then
    DROPBEAR="${GREEN}🟢 ONLINE${NC}"
else
    DROPBEAR="${RED}🔴 OFFLINE${NC}"
fi

# ================= USER COUNT =================

VMESS=$(jq '[.inbounds[] | select(.tag=="vmess-ws-tls").settings.clients[]] | length' $CONFIG 2>/dev/null)

VLESS=$(jq '[.inbounds[] | select(.tag=="vless-ws-tls").settings.clients[]] | length' $CONFIG 2>/dev/null)

TROJAN=$(jq '[.inbounds[] | select(.tag=="trojan-ws-tls").settings.clients[]] | length' $CONFIG 2>/dev/null)

SSWS=$(jq '[.inbounds[] | select(.tag=="ssws-ws-tls").settings.clients[]] | length' $CONFIG 2>/dev/null)

ZIVPN_USER=$(grep -vc '^$' /etc/zivpn/users.db 2>/dev/null)

SSH_USER=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)

TOTAL=$((VMESS + VLESS + TROJAN + SSWS + ZIVPN_USER + SSH_USER))

ONLINE=$(tail -n 500 /var/log/xray/access.log 2>/dev/null | 
grep -Eo 'tcp:[0-9]+.[0-9]+.[0-9]+.[0-9]+' | 
cut -d':' -f2 | sort -u | wc -l)

# ===== INIT =====

clear

echo -ne "${MAGENTA}"
printf "⚡ Loading ABDELRAHMAN RABIE XRAY PANEL ⚡" | type_text
echo -e "${NC}"

loading "Loading System Modules"
loading "Checking Services"
loading "Reading Traffic Database"

echo ""
echo -e "${GREEN}✔ System Ready!${NC}"

sleep 1
clear

# ================= HEADER =================

theme_banner "⚡ PREMIUM XRAY CONTROL PANEL ⚡"

# ================= SYSTEM INFO =================

theme_section "SYSTEM INFO"

printf " ${AQUA}IP VPS      ${NC}: %-25s\n" "$IP"
printf " ${AQUA}DOMAIN      ${NC}: %-25s\n" "$DOMAIN"
printf " ${AQUA}ISP         ${NC}: %-25s\n" "$ISP"
printf " ${AQUA}OS          ${NC}: %-25s\n" "$OS"
printf " ${AQUA}UPTIME      ${NC}: %-25s\n" "$UPTIME"
printf " ${AQUA}CPU USAGE   ${NC}: %-25s\n" "$CPU"
printf " ${AQUA}RAM USAGE   ${NC}: %-25s\n" "$RAM"
printf " ${AQUA}DISK USAGE  ${NC}: %-25s\n" "$DISK"
printf " ${AQUA}SERVER TIME ${NC}: %-25s\n" "$TIME"

theme_end

# ================= BANDWIDTH =================

theme_section "BANDWIDTH"

printf " ${AQUA}TODAY${NC}   : %-10s" "$TODAY"
printf " ${AQUA}YESTERDAY${NC}  : %-10s\n" "$YESTERDAY"

printf " ${AQUA}MONTH${NC}   : %-10s" "$MONTH"
printf " ${AQUA}TOTAL${NC}      : %-10s\n" "$TOTAL_BW"

theme_end

# ================= USER ==================

theme_section "USER STATS"

echo -e " ${AQUA}VMESS${NC} : $VMESS     ${AQUA}VLESS${NC} : $VLESS     ${AQUA}TROJAN${NC} : $TROJAN"

echo -e " ${AQUA}SSWS${NC}  : $SSWS     ${AQUA}SSH${NC}   : $SSH_USER     ${AQUA}ZIVPN${NC} : $ZIVPN_USER"

echo -e " ${AQUA}TOTAL${NC} : $TOTAL    ${AQUA}ONLINE${NC} : $ONLINE"

theme_end

# ================= SERVICE =================

theme_section "SERVICE"

echo -e " ${AQUA}XRAY${NC}      : $XRAY  ${AQUA}NGINX${NC}     : $NGINX     "
echo -e " ${AQUA}DROPBEAR${NC}  : $DROPBEAR  ${AQUA}WIREGUARD${NC} : $WG        "
echo -e " ${AQUA}UDP CUSTOM${NC}: $UDPCUSTOM  ${AQUA}UDP ZIVPN${NC} : $ZIVPN     "
echo -e " ${AQUA}SSH WS${NC}    : $DROPBEARWS ${AQUA}WSS${NC}       : $STUNNELWS "

theme_end

# ================= MENU =================

theme_section "MAIN MENU"

echo -e " ${MAGENTA}❮${GOLD}1${MAGENTA}❯${NC} ${WHITE}SSH${NC}          ${MAGENTA}❮${GOLD}8${MAGENTA}❯${NC} ${WHITE}TOOLS${NC}"
echo -e " ${MAGENTA}❮${GOLD}2${MAGENTA}❯${NC} ${WHITE}VMESS${NC}        ${MAGENTA}❮${GOLD}9${MAGENTA}❯${NC} ${WHITE}STATUS${NC}"
echo -e " ${MAGENTA}❮${GOLD}3${MAGENTA}❯${NC} ${WHITE}VLESS${NC}        ${MAGENTA}❮${GOLD}10${MAGENTA}❯${NC} ${WHITE}CLEAR RAM${NC}"
echo -e " ${MAGENTA}❮${GOLD}4${MAGENTA}❯${NC} ${WHITE}TROJAN${NC}       ${MAGENTA}❮${GOLD}11${MAGENTA}❯${NC} ${WHITE}REBOOT VPS${NC}"
echo -e " ${MAGENTA}❮${GOLD}5${MAGENTA}❯${NC} ${WHITE}SSWS${NC}         ${MAGENTA}❮${GOLD}12${MAGENTA}❯${NC} ${WHITE}UNINSTALL${NC}"
echo -e " ${MAGENTA}❮${GOLD}6${MAGENTA}❯${NC} ${WHITE}WIREGUARD${NC}    ${MAGENTA}❮${GOLD}13${MAGENTA}❯${NC} ${WHITE}UDP CUSTOM${NC}"
echo -e " ${MAGENTA}❮${GOLD}7${MAGENTA}❯${NC} ${WHITE}UDP ZIVPN${NC}    ${MAGENTA}❮${GOLD}x${MAGENTA}❯${NC} ${WHITE}EXIT${NC}"

theme_end

theme_section "DEVELOPER"
echo -e " ${AQUA}Developer${NC} : ${GOLD}Eng.Abdelrahman Rabie${NC}"
echo -e " ${AQUA}Edition${NC}   : ${WHITE}Royal Neon ${PANEL_VERSION}${NC}"
theme_footer

read -rp "$(echo -e "${GOLD}❯ Select Menu : ${NC}")" menu

case $menu in
1) m-ssh ;;
2) m-vmess ;;
3) m-vless ;;
4) m-trojan ;;
5) m-ssws ;;
6) m-wg ;;
7) m-zivpn ;;
8) tools-menu ;;
9) running ;;
10) clearcache ;;
11) reboot ;;
12) bash /root/uninstall.sh ;;
13) systemctl status udp-custom ;;
x) exit ;;
*)
echo -e "${RED}❌ Invalid menu!${NC}"
sleep 1
exec "$0"
;;
esac
