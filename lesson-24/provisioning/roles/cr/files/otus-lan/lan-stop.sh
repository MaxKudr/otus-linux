#!/usr/bin/env bash

for i in 11 22; do
	ip netns exec lan$i ip l set vlan$i netns 1
	ip l delete dev master-lan$i
	ip netns delete lan$i
done
