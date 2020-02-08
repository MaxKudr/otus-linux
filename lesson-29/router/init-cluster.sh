#!/usr/bin/env bash
yum install -y mysql-shell

CLUSTER_NAME="otus"
ETCD_SERVER="etcd"
ETCD_PORT="2379"
ETCD="/usr/bin/etcdctl --endpoint http://${ETCD_SERVER}:${ETCD_PORT}"
NODES="${CLUSTER_MEMBERS:-3}"
MYSQL_HOST=""
MYSQLSH="mysqlsh --uri ${MYSQL_USER}:$(cat ${PASSFILE})"

wait_etcd_service() {
	ret=1
	while [[ $ret -gt 0 ]]; do
		echo Waiting cluster info into etcd service
		ret=$(${ETCD} ls cluster &>/dev/null; echo $?)
		sleep 3s
	done
}


wait_nodes() {
	nodes=0
	while [[ ${nodes} -lt ${NODES} ]]; do
		nodes=$(${ETCD} ls cluster/${CLUSTER_NAME} | wc -l)
		echo "Waiting nodes ${nodes}/${NODES}"
		sleep 3s
	done
}


init_cluster () {
	path_list=$(${ETCD} ls cluster/${CLUSTER_NAME})

	for node_path in ${path_list}; do
		node=${node_path#/cluster/${CLUSTER_NAME}/}
		echo "Search cluster on node ${node}"
		MYSQL_HOST=$(mysqlsh --uri "${MYSQL_USER}:$(cat ${PASSFILE})@${node}" -e "try{cl=dba.getCluster('${CLUSTER_NAME}')}catch(e){}if(typeof cl !== 'undefined'){print('${node}')}")

		[[ ! -z "${MYSQL_HOST}" ]] && break
	done

	for node_path in ${path_list}; do
		node=${node_path#/cluster/${CLUSTER_NAME}/}

		[[ "${MYSQL_HOST}" == "${node}" ]] && continue

		if [[ -z "${MYSQL_HOST}" ]]; then
			echo "Create cluster via node ${node}"
			mysqlsh --uri "${MYSQL_USER}:$(cat ${PASSFILE})@${node}" -e "try{cl=dba.getCluster('${CLUSTER_NAME}')}catch(e){}if(typeof cl === 'undefined'){dba.createCluster('${CLUSTER_NAME}')}"
			MYSQL_HOST=${node}
			continue
		fi

		echo "Adding node ${node} via ${MYSQL_HOST}"
		mysqlsh --uri "${MYSQL_USER}:$(cat ${PASSFILE})@${MYSQL_HOST}" -e "dba.getCluster('${CLUSTER_NAME}').addInstance('${MYSQL_USER}:$(cat ${PASSFILE})@${node}:3306',{recoveryMethod:'incremental'})"
	done
}


wait_etcd_service
wait_nodes
init_cluster
