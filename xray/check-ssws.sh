#!/bin/bash
# Check SS WS login - by Eng.Abdelrahman Rabie

echo -e "🔍 Active SS WS connection log:"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log_file="/var/log/xray/access.log"

if [[ ! -f $log_file ]]; then
    echo "❌ Log file not found!"
    exit 1
fi

grep 'accepted' $log_file | awk '{print $3}' | cut -d':' -f1 | sort | uniq -c | sort -nr
