#!/usr/bin/env bash
set -f

# get CPU clock tick
CLK_TCK=$(getconf CLK_TCK)

# get terminal width
SCREEN_WIDTH=$(/usr/bin/tput cols)

# fill available devices
declare -A DEVICES
while read id name; do
	[[ "x${name%%/*}" == "x" ]] && continue
	[[ -v DEVICES[$id] ]] && continue
	[[ "x$id" != "x" ]] && DEVICES[$id]="$name"
done < /proc/devices

{
	echo -e "PID\tTTY\tSTAT\tTIME\tCOMMAND"
	find /proc -maxdepth 1 -regex ".*/[0-9]*" | while read sproc; do
		[[ ! -f "$sproc/stat" ]] && continue

		read sstat < "$sproc/stat"
		comm=${sstat##*(}
		comm="[${comm%%)*}]"
		sstat=${sstat%%(*}${sstat##*)}

		read pid state ppid pgrp session tty_nr tpgid flags minflt cminflt majflt cmajflt utime stime cutime cstime priority nice num_threads itrealvalue starttime vsize rss rsslim startcode endcode startstack kstkesp kstkeip signal blocked sigignore sigcatch wchan nswap cnswap exit_signal processor rt_priority policy delayacct_blkio_ticks guest_time cguest_time start_data end_data start_brk arg_start arg_end env_start env_end exit_code <<< $sstat

		fcomm=""
		while IFS= read -d '' word; do
			fcomm=$fcomm" "$word
		done < "$sproc/cmdline"
		fcomm=${fcomm# }

		time=$((($utime + $stime) / $CLK_TCK))
		mtime=$(($time/60))
		stime=$(($time - $mtime*60))

		[[ $ppid -ne 2 ]] && comm="$fcomm"

		tty_major=$(( $tty_nr >> 8 & 0xFF ))
		tty_minor=$(( ($tty_nr >> 12 & 0xFFF0) | ($tty_nr & 0xFF) ))

		[[ $tty_major -eq 0 ]] && stty="?" || stty="${DEVICES[${tty_major}]}/${tty_minor}"

		printf "%d\t%s\t%s\t%d:%d\t%s\n" "$pid" "$stty" "$state" "$mtime" "$stime" "$comm"
	done
} | column -ts $'\t' | cut -c-${SCREEN_WIDTH}
