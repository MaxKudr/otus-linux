#!/usr/bin/env bash

function print_usage {
	echo -e "\nUsage: $(basename "${0}") OPTIONS\n"
	cat << EOF
  -p PID -- show process list of files
  --help -- show this help

EOF
}


function load_users {
	IFS=":"
	while read -r _name _pass _uid _other; do
		__users[$_uid]="$_name"
	done < "/etc/passwd"
}


function get_comm {
	local _stat=$1
	local _ret=$2

	_comm=${_stat##*(}
	_comm=${_comm%%)*}

	eval "$_ret='$_comm'"
}


function get_pid {
	local _proc=$1
	local _ret=$2

	_pid=${_proc##*/}

	eval "$_ret='$_pid'"
}


function get_tid {
	local _task=$1
	local _ret=$2

	_tid=${_task##*/}

	eval "$_ret='$_tid'"
}


function get_user {
	local _task=$1
	local _ret=$2
	local _uid

	read -r _uid < "$_task/loginuid"
	[[ $_uid -eq 4294967295 ]] && _uid="0"

	eval "$_ret='${__users[$_uid]}'"
}


function _get_file_info {
	local __files=("$@")
	local __type='unknown'
	local __rl_files=()

	IFS=$'\n'
	for __orig_file in "${__files[@]}"; do
		read -r line;
		[[ $line =~ "pipe:" ]] && line="pipe"
		[[ $line =~ "socket:" ]] && line="type=STREAM"
		__rl_files+=("$line")
	done < <(readlink -m "${__files[@]}")

	for __orig_file in "${__rl_files[@]}"; do
		IFS=$'\t' read -r __F __D __S __I __n
		[[ $__F =~ "regular file" ]] && __type="REG"
		[[ $__F =~ "directory" ]] && __type="DIR"
		[[ $__F =~ "character special file" ]] && __type="CHR"
		[[ $__F =~ "socket" ]] && __type="unix"

		[[ $__orig_file =~ \ \(deleted\) ]] && __type="REG"

		if [[ $__F =~ "cannot stat" ]]; then
			[[ $__F =~ "Permission denied" ]] && __orig_file="$__orig_file (readlink permission denied)"
		fi

		printf "%s\t%s\t%s\t%s\t%s\n" "${__type:- }" "${__D:- }" "${__S:- }" "${__I:- }" "$__orig_file"
	done < <(stat -L --printf "%F\t%t,%T\t%s\t%i\t%n\n" "${__files[@]}" 2>&1)
}


function gets_main_files {
	local _task=$1

	files=("$_task/cwd")
	while read -r line; do
		printf "cwd\t%s\n" "$line"
	done < <(_get_file_info "${files[@]}")

	files=("$_task/root")
	while read -r line; do
		printf "rtr\t%s\n" "$line"
	done < <(_get_file_info "${files[@]}")

	files=("$_task/exe")
	while read -r line; do
		printf "txt\t%s\n" "$line"
	done < <(_get_file_info "${files[@]}")
}


function gets_mmap_files {
	local _task=$1
	local _type

	declare -A _files

	if [[ -O "$_task/maps" ]]; then
		while IFS=' ' read -r _addr _perms _offset _dev _inode _name; do
			[[ ! $_dev == "00:00" ]] && _files["$_name"]="$_name"
		done < "$_task/maps"
	fi

	if [[ ${#_files[@]} -ne 0 ]]; then
		for _file in "${_files[@]}"; do
			read -r line
			_type="mem"
			[[ $_file =~ \ \(deleted\) ]] && line=${line% (deleted)} && _type="DEL"
			printf "%s\t%s\n" "$_type" "$line"
		done < <(_get_file_info "${_files[@]}")
	fi
}


function gets_fd_files {
	local _task=$1

	declare -A _files

	if [[ -O "$_task/fd" ]]; then
		for _file in "$_task/fd"/*; do
			_files["$_file"]="$_file"
		done
	fi

	if [[ ${#_files[@]} -ne 0 ]]; then
		for _file in "${_files[@]}"; do
			read -r line
			fid=${_file##*/}
			[[ $_file =~ \ \(deleted\) ]] && line=${line% (deleted)} && _type="DEL"
			printf "%3s\t%s\n" "$fid" "$line"
		done < <(_get_file_info "${_files[@]}")
	fi
}


function main {
	{
		printf "%.9s\t%s\t%s\t%.12s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "COMMAND" "PID" "TID" "TASKCMD" "USER" "FD" "TYPE" "DEVICE" "SIZE/OFF" "NODE" "NAME"
		for sproc in $1; do
			[[ ! -f "$sproc/stat" ]] && continue

			read -r pstat < "$sproc/stat"
			get_comm "$pstat" pcomm

			for stask in "$sproc/task"/[0-9]*; do
				[[ ! -f "$stask/stat" ]] && continue

				read -r tstat < "$stask/stat"
				get_comm "$tstat" tcomm

				get_pid "$sproc" pid
				get_tid "$stask" tid

				[[ $pid -eq $tid ]] && pinfo="$sproc" || pinfo="$stask"
				[[ $pid -eq $tid ]] && tid="" && tcomm=""

				get_user "$stask" user

				{
					gets_main_files "$pinfo"
					gets_mmap_files "$pinfo"
					gets_fd_files "$pinfo"
				} | while read -r line; do
					IFS=$'\t' read -r fd stype device size mode name<<< "$line"

					printf "%.9s\t%s\t%s\t%.12s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "$pcomm" "$pid" "$tid" "$tcomm" "$user" "$fd" "$stype" "$device" "$size" "$mode" "$name"
				done

			done
		done
	} | column -ts $'\t' -o ' '
}


PROC="/proc/[0-9]*"
while :
do
	case "$1" in
		-p)
			PROC="/proc/${2}"
			shift 2
			;;
		--help)
			print_usage
			exit
			;;
		*)
			break
			;;
	esac

	RET=$?
	[ $RET -gt 0 ] && break;
done

declare -A __users
load_users

main "$PROC"
