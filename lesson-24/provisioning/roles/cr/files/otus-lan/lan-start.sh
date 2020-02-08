#!/usr/bin/env bash

for i in 11 22; do
	ip netns add lan$i
	ip l set vlan$i netns lan$i
	ip netns exec lan$i ip a add 10.10.10.100/24 dev vlan$i
	ip netns exec lan$i ip l set up vlan$i
	ip l add dev master-lan$i type veth peer name slave-lan$i
	ip a add 10.10.$i.1/29 dev master-lan$i
	ip l set up dev master-lan$i
	ip l set slave-lan$i netns lan$i
	ip netns exec lan$i ip a add 10.10.$i.2/29 dev slave-lan$i
	ip netns exec lan$i ip l set up dev slave-lan$i
	ip netns exec lan$i ip r add default via 10.10.$i.1
	ip netns exec lan$i iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -j SNAT --to 10.10.$i.2
done
