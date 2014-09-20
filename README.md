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

Note that port `9300` (tcp) is also exposed, but is not required unless you
want to build a multi-node cluster using this container :wink:

### Data and volumes

This container exposes `/data` as bind mount volume. You can mount it when
starting the container:

```
docker run -v /mydata/elasticsearch:/data -d -p 9200:9200 mini/elasticsearch
```

We recommend you mount the volume to avoid loosing data between updates to
the container.

## Sponsor

Work on this was made possible thanks to [AREA 17](http://www.area17.com).

## License

All the code contained in this repository, unless explicitly stated, is
licensed under ISC license.

A copy of the license can be found inside the [LICENSE](LICENSE) file.
