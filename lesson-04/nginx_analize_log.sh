#!/usr/bin/env bash

TIME_FILE="/tmp/script_time"
LOCK_FILE="/tmp/script.lock"
REPORT_FILE=$(mktemp)
HELPER=$(mktemp)

function print_usage {
	echo -e "\nUsage: $(basename "${0}") OPTIONS\n"
	cat << EOF
  -e, --email     -- send report to EMAIL address
  -s, --subject   -- subject of email
  -i, --iptop     -- show top X IP addresses from last time
  -u, --urltop    -- show top Y requested URL from last time
  -l, --logdir    -- path to nginx log files directory
  -f, --from-time -- analize log from TIME. TIME should in second from start unix epoch
  --help          -- show this help

EOF
}


function update_last_time {
	date +%s > "$TIME_FILE"
}


function get_last_time {
	[ -f "$TIME_FILE" ] || update_last_time
	cat "$TIME_FILE"
}


function make_helper {
	cat << EOF > "$HELPER"
#!/usr/bin/env python
import sys
import re
from dateutil import parser

for line in sys.stdin:
    s = re.search('\[(.+?)\]', line).group(1)
    t = parser.parse(s.replace(':', ' ', 1)).strftime('%s')
    print t,line
EOF
}


function create_report {
	true > "$REPORT_FILE"
	REP_START_DATE=$(date -d "@${LAST_TIME}" "+%d.%m.%Y %H:%M:%S %Z")
	REP_END_DATE=$(date "+%d.%m.%Y %H:%M:%S %Z")

	{
		echo -e "Report from $REP_START_DATE - $REP_END_DATE\n  Count IPs\n--------------------"
		cat "$REP_IP"

		echo -e "\n\n  Count URLs\n--------------------"
		cat "$REP_URL"

		echo -e "\n\n  Count Return codes\n--------------------"
		cat "$REP_CODE"
	} >> "$REPORT_FILE"
}


function send_report {
	echo -e "RCPTTO: ${EMAIL}\nSUBJ: ${SUBJ}\nBODY:"
	cat "$REPORT_FILE"
}


function clean_temp {
	for tmp_file in "$HELPER" \
	                "$FIFO_IP" "$REP_IP" \
	                "$FIFO_URL" "$REP_URL" \
	                "$FIFO_CODE" "$REP_CODE" \
	                "$REPORT_FILE"; do
		rm -f "$tmp_file";
	done;
}

while :
do
	case "$1" in
		-e|--email) # Email address
			EMAIL="$2"
			shift 2
			;;
		-s|--subject) # Subject of email
			SUBJ="$2"
			shift 2
			;;
		-i|--iptop) # Count of top IP addresses
			IPTOP="$2"
			shift 2
			;;
		-u|--urltop) # Count of requested URLs
			URLTOP="$2"
			shift 2
			;;
		-l|--logdir) # Nginx log files directory
			LOGDIR="$2"
			shift 2
			;;
		-f|--from-time) # Start from epoch seconds
			LAST_TIME="$2"
			shift 2
			;;
		--help) # Show help
			print_usage
			exit
			;;
		*) break
			;;
	esac

	RET=$?
	[ $RET -gt 0 ] && break;
done


[ "x$LOGDIR" = "x" ] && echo "Please set '-l|--logdir' option. Exit" && exit 2
[ "x$EMAIL" = "x" ] && echo "Please set '-e|--email' option. Exit" && exit 3
[ "x$IPTOP" = "x" ] && echo "Please set '-i|--iptop' option. Exit" && exit 4
[ "x$URLTOP" = "x" ] && echo "Please set '-u|--urltop' option. Exit" && exit 5

[ "x$LAST_TIME" = "x" ] && LAST_TIME=$(get_last_time)

if [ ! -f "$LOCK_FILE" ]; then
	echo "$$" > "$LOCK_FILE"
	trap 'rm -f "${LOCK_FILE}"; exit $?' INT TERM EXIT

	FIFO_IP=$(mktemp -u)
	FIFO_URL=$(mktemp -u)
	FIFO_CODE=$(mktemp -u)

	mkfifo "$FIFO_IP" "$FIFO_URL" "$FIFO_CODE"

	REP_IP=$(mktemp)
	REP_URL=$(mktemp)
	REP_CODE=$(mktemp)

	# Calculate TOP IP
	(awk '{print $2}' "$FIFO_IP" | sort | uniq -c | sort -rh | head -"$IPTOP" >"$REP_IP")& PID_IP=$!

	# Calculate TOP URL
	(sed 's/^.*\] \"//; s/\".*$//' "$FIFO_URL" | sort | uniq -c | sort -rh | head -"$URLTOP" >"$REP_URL")& PID_URL=$!

	# Calculate return codes
	(perl -pe 's/^.*?".*?" //' "$FIFO_CODE" | cut -d' ' -f1 | sort | uniq -c | sort -rh >"$REP_CODE")& PID_CODE=$!

	# filtering logs by time
	make_helper
	find "$LOGDIR" -maxdepth 1 -type f -name "access.log*" | while read access_file; do
		ext=${access_file##*.};

		[ "x$ext" = "xgz" ] && cat="zcat" || cat="cat"

		$cat "$access_file"

	done | python "$HELPER" | awk -v last_time="$LAST_TIME" 'last_time <= $1 {print $0}' | tee "$FIFO_IP" "$FIFO_URL" "$FIFO_CODE" > /dev/null

	wait $PID_IP $PID_URL $PID_CODE

	create_report
	send_report
	update_last_time

	# remove all temporary files
	clean_temp

	trap - INT TERM EXIT
	rm -f "$LOCK_FILE"
else
	PID=$(cat $LOCK_FILE)
	echo "Another script with pid ${PID} already running"
fi
