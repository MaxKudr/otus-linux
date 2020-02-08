#!/usr/bin/env bash
CLUSTER_NAME="otus"
ETCD_SERVER="etcd"
ETCD_PORT="2379"
ETCD="/usr/bin/etcdctl --endpoint http://${ETCD_SERVER}:${ETCD_PORT}"

timestamp=$(date +%s)
ipaddr=$(getent hosts $(hostname) | awk '{print $1}')

wait_etcd_service() {
	ret=1
	while [ $ret -gt 0 ]; do
		echo Waiting etcd service
		sleep 3s
		ret=$(${ETCD} ls &>/dev/null; echo $?)
	done
}


register_node() {
	${ETCD} set cluster/${CLUSTER_NAME}/${ipaddr} ${timestamp} 1>/dev/null
}


wait_etcd_service
register_node
