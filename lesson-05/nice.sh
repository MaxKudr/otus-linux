#!/usr/bin/env bash

FIFO1=$(mktemp -u)
FIFO2=$(mktemp -u)
mkfifo "$FIFO1" "$FIFO2"

trap 'rm -f "$FIFO1" "$FIFO2"' INT TERM EXIT

( (time nice -0 dd if=/dev/urandom bs=5M count=50 | md5sum) 2>&1 | tee "$FIFO1" > /dev/null)& PID_P1=$!
( (time nice -19 dd if=/dev/urandom bs=5M count=50 | md5sum) 2>&1 | tee "$FIFO2" > /dev/null)& PID_P2=$!

echo "Proccess #1 started with \"nice -0\""
echo "Proccess #2 started with \"nice -19\""

RES1=$(grep real "$FIFO1")
RES2=$(grep real "$FIFO2")

wait $PID_P1 $PID_P2

echo "Real time for proccess #1: ${RES1#real}"
echo "Real time for proccess #2: ${RES2#real}"

rm -f "$FIFO1" "$FIFO2"
