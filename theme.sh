#!/bin/bash
# ==========================================================
#  ABDELRAHMAN AUTOSCRIPT - THEME
#  Developed by Eng.Abdelrahman Rabie
#  Shared palette + UI helpers (256-colour terminals)
#  Installed to /etc/autoscriptvpn/theme.sh by setup.sh
# ==========================================================

THEME_OWNER="Eng.Abdelrahman Rabie"
THEME_NAME="Abdelrahman AutoScript"
THEME_EDITION="V3.0"
TW=46                                   # inner width of boxes

# ---------- palette ----------
NC='\033[0m'
BOLD='\033[1m'
VIOLET='\033[1;38;5;99m'
PURPLE='\033[1;38;5;135m'
ORCHID='\033[1;38;5;171m'
MAGENTA='\033[1;38;5;201m'
PINK='\033[1;38;5;213m'
GOLD='\033[1;38;5;220m'
AQUA='\033[1;38;5;51m'
NEON='\033[1;38;5;48m'
ROSE='\033[1;38;5;203m'
SNOW='\033[1;38;5;231m'
GREY='\033[0;38;5;245m'
BG_TITLE='\033[48;5;54;1;38;5;231m'

# ---------- gradient (violet -> magenta -> pink) ----------
GRAD=(57 93 129 165 201 207)

# character length that works in any locale (UTF-8 or C/POSIX)
_ulen() { printf '%s' "$1" | LC_ALL=C tr -d '\200-\277' | LC_ALL=C wc -c | tr -d ' '; }

_gc() { printf '\033[1;38;5;%sm' "$1"; }

# grad_line LEFT FILL RIGHT
grad_line() {
    local i idx out=""
    out+="$(_gc "${GRAD[0]}")$1"
    for ((i = 0; i < TW; i++)); do
        idx=$(( i * ${#GRAD[@]} / TW ))
        out+="$(_gc "${GRAD[$idx]}")$2"
    done
    out+="$(_gc "${GRAD[${#GRAD[@]}-1]}")$3${NC}"
    printf '%b\n' "$out"
}

# center_row "text" [colour]   -> ║   text   ║
center_row() {
    local text="$1" color="${2:-$SNOW}"
    local len; len=$(_ulen "$text")
    local pad=$(( TW - len ))
    (( pad < 0 )) && pad=0
    local l=$(( pad / 2 ))
    local r=$(( pad - l ))
    printf '%b║%*s%b%s%b%*s%b║%b\n' \
        "$(_gc "${GRAD[0]}")" "$l" "" "$color" "$text" "$NC" "$r" "" \
        "$(_gc "${GRAD[${#GRAD[@]}-1]}")" "$NC"
}

# theme_banner ["subtitle"]  -> product name + optional subtitle (sub-menus)
theme_banner() {
    grad_line "╔" "═" "╗"
    center_row "✦  ${THEME_NAME}  ✦" "$GOLD"
    [[ -n "$1" ]] && center_row "$1" "$AQUA"
    grad_line "╚" "═" "╝"
}

# theme_banner_main -> product name + developer + edition (main menu)
theme_banner_main() {
    grad_line "╔" "═" "╗"
    center_row "✦  ${THEME_NAME}  ✦" "$GOLD"
    center_row "Developer: ${THEME_OWNER}" "$AQUA"
    center_row "Edition ${THEME_EDITION}" "$PINK"
    grad_line "╚" "═" "╝"
}

# theme_section "TITLE"   -> ┏━━━━━ TITLE ━━━━━┓  (gradient)
theme_section() {
    local title=" $1 "
    local len; len=$(_ulen "$title")
    local rest=$(( TW - len ))
    (( rest < 2 )) && rest=2
    local l=$(( rest / 2 ))
    local r=$(( rest - l ))
    local i out=""
    out+="$(_gc "${GRAD[0]}")┏"
    for ((i = 0; i < l; i++)); do
        out+="$(_gc "${GRAD[$(( i * ${#GRAD[@]} / (l + 1) ))]}")━"
    done
    out+="${GOLD}${title}"
    for ((i = 0; i < r; i++)); do
        out+="$(_gc "${GRAD[$(( ${#GRAD[@]} - 1 - i * ${#GRAD[@]} / (r + 1) ))]}")━"
    done
    out+="$(_gc "${GRAD[${#GRAD[@]}-1]}")┓${NC}"
    printf '%b\n' "$out"
}

# theme_end  -> ┗━━━━━━━━━━┛
theme_end() { grad_line "┗" "━" "┛"; }

# theme_rule -> plain gradient divider
theme_rule() { grad_line "━" "━" "━"; }

# theme_title "TEXT"  -> coloured title bar (replaces blue title bar)
theme_title() {
    local len; len=$(_ulen "$1")
    local l=$(( (TW + 2 - len) / 2 ))
    local r=$(( TW + 2 - len - l ))
    printf '%b%*s%s%*s%b\n' "$BG_TITLE" "$l" "" "$1" "$r" "" "$NC"
}

# theme_item KEY "Label"   ->   ❮1❯  Label
theme_item() {
    printf '  %b❮%b%s%b❯%b  %b%s%b\n' \
        "$MAGENTA" "$GOLD" "$1" "$MAGENTA" "$NC" "$SNOW" "$2" "$NC"
}

# theme_kv "Label" "Value"
theme_kv() {
    printf ' %b%-12s%b: %b%s%b\n' "$AQUA" "$1" "$NC" "$SNOW" "$2" "$NC"
}

# theme_footer -> credit line
theme_footer() {
    grad_line "┗" "━" "┛"
    printf '%b%*s%s%b\n' "$GREY" 4 "" "© $(date +%Y) ${THEME_OWNER} — All rights reserved" "$NC"
}

# status helpers
theme_ok()   { printf '%b[ ✔ ]%b %s\n' "$NEON" "$NC" "$1"; }
theme_warn() { printf '%b[ ! ]%b %s\n' "$GOLD" "$NC" "$1"; }
theme_err()  { printf '%b[ ✘ ]%b %s\n' "$ROSE" "$NC" "$1"; }
theme_info() { printf '%b[ i ]%b %s\n' "$AQUA" "$NC" "$1"; }

# ==========================================================
#  Network info helpers (cached, multi-provider fallback)
#  Fixes the "429 Rate limit hit" message from single-provider lookups.
# ==========================================================
CACHE_DIR="/etc/autoscriptvpn/cache"

_cache_read() {   # _cache_read FILE MAX_AGE_SECONDS
    [[ -s "$1" ]] || return 1
    local age=$(( $(date +%s) - $(stat -c %Y "$1" 2>/dev/null || echo 0) ))
    (( age <= $2 )) || return 1
    cat "$1"
}

_cache_write() {  # _cache_write FILE VALUE
    mkdir -p "$CACHE_DIR" 2>/dev/null && printf '%s' "$2" > "$1" 2>/dev/null
}

_valid_line() {   # reject JSON / error pages / empty / too long
    [[ -n "$1" && ${#1} -le 80 && "$1" != *"{"* && "$1" != *"<"* \
       && "$1" != *"rate limit"* && "$1" != *"Rate limit"* && "$1" != *"error"* ]]
}

get_public_ip() {
    local ip url
    ip=$(_cache_read "$CACHE_DIR/ip" 600) && { printf '%s' "$ip"; return; }
    for url in https://ipv4.icanhazip.com https://api.ipify.org https://ifconfig.me/ip https://checkip.amazonaws.com; do
        ip=$(curl -s --max-time 4 "$url" | tr -d '[:space:]')
        if [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
            _cache_write "$CACHE_DIR/ip" "$ip"
            printf '%s' "$ip"; return
        fi
    done
    printf '%s' "N/A"
}

# get_isp IP  -> hosting company / ISP name (cached per IP for 7 days)
get_isp() {
    local ip="$1" cached isp
    if cached=$(_cache_read "$CACHE_DIR/isp" 604800) && [[ "${cached%%|*}" == "$ip" ]]; then
        printf '%s' "${cached#*|}"; return
    fi

    local url body
    for url in \
        "http://ip-api.com/line/${ip}?fields=isp" \
        "https://ipwho.is/${ip}" \
        "https://ipapi.co/${ip}/org/" \
        "https://api.iplocation.net/?ip=${ip}"; do
        body=$(curl -s --max-time 4 "$url" 2>/dev/null | tr -d '\r')
        case "$url" in
            *ipwho.is*)        isp=$(printf '%s' "$body" | grep -oP '"isp":\s*"\K[^"]+' | head -n1) ;;
            *iplocation.net*)  isp=$(printf '%s' "$body" | grep -oP '"isp":\s*"\K[^"]+' | head -n1) ;;
            *)                 isp=$(printf '%s' "$body" | head -n1) ;;
        esac
        if _valid_line "$isp"; then
            _cache_write "$CACHE_DIR/isp" "${ip}|${isp}"
            printf '%s' "$isp"; return
        fi
    done

    # reverse DNS as an offline-ish fallback
    isp=$(getent hosts "$ip" 2>/dev/null | awk '{print $2}' | awk -F. 'NF>=2{print $(NF-1)"."$NF}')
    _valid_line "$isp" && { printf '%s' "$isp"; return; }
    printf '%s' "Unknown"
}
