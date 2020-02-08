#!/usr/bin/env bash

MON_FILE="$1"
MON_SEARCH="$2"
MON_POS_FILE="/tmp/mon-log.pos"

[[ ! -f "$MON_FILE" ]] && exit 1

WC_FILE=$(wc -l "$MON_FILE")
WC_FILE=${WC_FILE%% *}

[[ -f "$MON_POS_FILE" ]] && LAST_POS=$(cat "$MON_POS_FILE") || LAST_POS=0
POS=$((WC_FILE - LAST_POS))
[[ $POS -lt 0 ]] && POS=0

(tail -"$POS" "$MON_FILE" | grep -q "$MON_SEARCH")
RET=$?

echo -en "$WC_FILE" >"$MON_POS_FILE"

[[ $RET -eq 0 ]] && echo "Find \"$MON_SEARCH\" in file $MON_FILE" | systemd-cat -t mon-log

exit 0
