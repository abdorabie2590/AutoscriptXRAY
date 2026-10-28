#!/bin/bash
# Cek login SS WS - by Eng.Abdelrahman Rabie

echo -e "🔍 Log koneksi aktif SS WS:"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log_file="/var/log/xray/access.log"

if [[ ! -f $log_file ]]; then
    echo "❌ Log file tidak ditemukan!"
    exit 1
fi

grep 'accepted' $log_file | awk '{print $3}' | cut -d':' -f1 | sort | uniq -c | sort -nr
