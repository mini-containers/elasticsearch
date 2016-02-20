# mini/elasticsearch

[Elasticsearch](http://www.elasticsearch.org/) service container.

## Usage

To run this container and bind port `9200`:

```
docker run -d -p 9200:9200 mini/elasticsearch
```

You can now check the logs:

```
docker logs <CONTAINER_ID>
```

You can also control the HTTP transport port to be something other than
`9200`, simply use `ELASTICSEARCH_PORT` and ensure the one given matches
the one being exposed by Docker.

Note that port `9300` (tcp) is also exposed, but is not required unless you
want to build a multi-node cluster using this container :wink:

### Network binding

By default, Elasticsearch will bind to the first network interface available,
but sometimes that is not desired.

Example of this will be the usage of [Weave](http://weave.works/) network and
ensure Elasticsearch communication happens exclusively over Weave, private
network and not exposed to the Docker interface.

In this scenario, you can enable this by using `ELASTICSEARCH_NET` and provide
any of the accepted values as described in Elastic's [network module](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-network.html#network-interface-values)
documentation.

In the above described example, you will use `_ethwe:ipv4_` as value for the
environment variable:

```
docker run -e ELASTICSEARCH_NET=_ethwe:ipv4_ mini/elasticsearch
```

You can use other network options like ranges, see details described in the
link provided above.

### Data and volumes

This container exposes `/data` as bind mount volume. You can mount it when
starting the container:

```
docker run -v /mydata/elasticsearch:/data -d -p 9200:9200 mini/elasticsearch
```

We recommend you mount the volume to avoid loosing data between updates to
the container.

## Basic Authentication

While is not a strong security mechanism, Asquera's [http-basic](https://github.com/Asquera/elasticsearch-http-basic) plugin has been added to avoid pesky eyes to your
Elasticsearch installation.

Define `ELASTICSEARCH_AUTH=yes` to the container's environment and will enable
default credentials. Default username is `elastic`.

You can adjust both username and password by setting `ELASTICSEARCH_USER` and
`ELASTICSEARCH_PASS` respectively.

**Important**: If no password is defined, the container will generate one
randomly on each start. You can inspect the container logs for the generated
password but is strongly recommended you set one by using the environment
variables described above.

## Cluster and Node identification

For development purposes, both cluster and node names might be irrelevant, so
Elasticsearch's default behavior might be OK.

However, moving to a production environment, it is desired to control these
two options in order to ensure multiple instances running on the same cluster
are setup independently.

Use `ELASTICSEARCH_CLUSTER` and `ELASTICSEARCH_NODE` variables to define
which cluster name will use for discovery and which name will be used for
announcement to such cluster.

## Sponsor

Work on this was made possible thanks to [AREA 17](http://www.area17.com).

## License

All the code contained in this repository, unless explicitly stated, is
licensed under ISC license.

A copy of the license can be found inside the [LICENSE](LICENSE) file.
