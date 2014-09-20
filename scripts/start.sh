#!/bin/sh

local ELASTICSEARCH_YML="/opt/elasticsearch/config/elasticsearch.yml"

shutdown() {
	local pid=$1

	echo "=> Shutdown requested, stopping Elasticsearch..."

	curl --silent -XPOST 'http://localhost:9200/_cluster/nodes/_local/_shutdown' > /dev/null

	# wait for process to terminate
	wait $pid

	# return process exit code
	exit $?
}

start() {
	# launch as background process
	/opt/elasticsearch/bin/elasticsearch -Des.config=$ELASTICSEARCH_YML &

	local pid=$!

	trap "shutdown $pid" SIGINT SIGTERM

	wait
}

start
