#!/usr/bin/env bash

[[ $# -eq 0 ]] && echo "Please give me test dir" && exit

TEST_DIR=$1

FIFO1=$(mktemp -u)
FIFO2=$(mktemp -u)
mkfifo "$FIFO1" "$FIFO2"

F1="$TEST_DIR/f1"
F2="$TEST_DIR/f2"

trap 'rm -f "$FIFO1" "$FIFO2" "$F1" "$F2"' INT TERM EXIT

( (ionice -c3 dd if=/dev/urandom of="$F1" oflag=direct bs=512 count=1000 2>&1) | tee "$FIFO1" > /dev/null)& PID_F1=$!
( (ionice -c2 -n0 dd if=/dev/urandom of="$F2" oflag=direct bs=512 count=1000 2>&1) | tee "$FIFO2" > /dev/null)& PID_F2=$!

echo "Proccess #1 started with \"ionice -c3\""
echo "Proccess #2 started with \"ionice -c2 -n0\""

RES1=$(grep "copied" "$FIFO1")
RES2=$(grep "copied" "$FIFO2")

wait $PID_F1 $PID_F2

echo "Result for proccess #1: ${RES1#*copied, }"
echo "Result for proccess #2: ${RES2#*copied, }"

rm -f "$FIFO1" "$FIFO2" "$F1" "$F2"
