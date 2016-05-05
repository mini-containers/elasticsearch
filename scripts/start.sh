#!/bin/sh

local ES_YML="/opt/elasticsearch/config/elasticsearch.yml"
local ES_OPTS="-Des.config=$ES_YML"
local ES_HTTP_PORT="9200"

set_authentication() {
	local _use_auth=${ELASTICSEARCH_AUTH:-"no"}

	if [ ${_use_auth} == "yes" ]; then
		# use default user if none is provided
		local _username=${ELASTICSEARCH_USER:-"elastic"}

		# use provided password or generate a random one
		local _pass=${ELASTICSEARCH_PASS:-$(pwgen -s 22 1)}
		local _type=$( [ ${ELASTICSEARCH_PASS} ] && echo "defined" || echo "generated" )

		echo "=> Enable HTTP Basic Authentication..."
		ES_OPTS="$ES_OPTS -Des.http.basic.enabled=true -Des.http.basic.user=${_username} -Des.http.basic.password=${_pass}"

		echo "======================================================================"
		echo " Use the following URL to connect to this Elasticsearch server:"
		echo ""

		if [ ${_type} == "generated" ]; then
			echo "   http://$_username:$_pass@<host>:<port>/"
			echo ""
			echo "  !!! IMPORTANT !!!"
			echo ""
			echo "  The password shown above is a random one and should be replaced"
			echo "  by your own using `ELASTICSEARCH_PASS` environment variable."
			echo ""
		else
			echo "   http://$_username:<not shown>@<host>:<port>/"
			echo ""
		fi

		echo "======================================================================"
	fi
}

set_http_port() {
	local _http_port=${ELASTICSEARCH_PORT:-"9200"}

	if [ ! "${_http_port}" == "9200" ]; then
		echo "=> Using port '${_http_port}'"
		ES_HTTP_PORT="${_http_port}"
		ES_OPTS="$ES_OPTS -Des.http.port=${_http_port}"
	fi
}

set_identification() {
	local _cluster_name=${ELASTICSEARCH_CLUSTER:-"elasticsearch"}
	local _node_name=${ELASTICSEARCH_NODE:-"noname"}

	if [ ! "${_cluster_name}" == "elasticsearch" ]; then
		echo "=> Cluster name is '${_cluster_name}'"
		ES_OPTS="$ES_OPTS -Des.cluster.name=\"${_cluster_name}\""
	fi

	if [ ! "${_node_name}" == "noname" ]; then
		echo "=> Node name is '${_node_name}'"
		ES_OPTS="$ES_OPTS -Des.node.name=\"${_node_name}\""
	fi
}

set_network_bind() {
	local _network=${ELASTICSEARCH_NET:-"any"}

	if [ ! "${_network}" == "any" ]; then
		echo "=> Using '${_network}' for network binding"
		ES_OPTS="$ES_OPTS -Des.network.host=${_network}"
	fi
}
shutdown() {
	local pid=$1

	echo "=> Shutdown requested, stopping Elasticsearch..."

	echo -e 'POST /_cluster/nodes/_local/_shutdown HTTP/1.0\r\n\r\n' | nc localhost $ES_HTTP_PORT > /dev/null

	# wait for process to terminate
	wait $pid

	# return process exit code
	exit $?
}

start() {
	set_network_bind
	set_http_port
	set_identification
	set_authentication

	# launch as background process
	/opt/elasticsearch/bin/elasticsearch "$ES_OPTS" &

	local pid=$!

	trap "shutdown $pid" SIGINT SIGTERM

	wait
}

start
