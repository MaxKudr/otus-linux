#!/usr/bin/env bash
conf="/etc/mysql/conf.d/cluster.cnf"
tmpconf="/tmp/cluster.cnf"

ipaddr=$(getent hosts $(hostname) | awk '{print $1}')

sed "/^server_id/s/0/${RANDOM}/; /^report-host/s/0.0.0.0/${ipaddr}/" ${tmpconf} > ${conf}
