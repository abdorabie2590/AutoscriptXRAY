#!/bin/bash
# ==========================================================
#  ROYAL NEON THEME
#  Developed by Eng.Abdelrahman Rabie
#  Shared palette + UI helpers (256-colour terminals)
#  Installed to /etc/autoscriptvpn/theme.sh by setup.sh
# ==========================================================

THEME_OWNER="Eng.Abdelrahman Rabie"
THEME_NAME="ABDELRAHMAN RABIE"
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

# theme_banner "subtitle"
theme_banner() {
    local sub="${1:-PREMIUM XRAY AUTOSCRIPT}"
    grad_line "╔" "═" "╗"
    center_row "✦  A B D E L R A H M A N   R A B I E  ✦" "$GOLD"
    center_row "$sub" "$AQUA"
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
