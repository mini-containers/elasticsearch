#!/bin/sh

local ELASTICSEARCH_YML="/opt/elasticsearch/config/elasticsearch.yml"

shutdown() {
  echo "=> Shutdown requested, stopping Elasticsearch..."

  curl --silent -XPOST 'http://localhost:9200/_cluster/nodes/_local/_shutdown' > /dev/null
  sleep 4

  exit 0
}

start() {
	# launch as background process
	/opt/elasticsearch/bin/elasticsearch -Des.config=$ELASTICSEARCH_YML &

  trap shutdown SIGINT SIGTERM

  wait
}

start
