FROM       mini/java
MAINTAINER Luis Lavena <luislavena@gmail.com>

ENV ELASTICSEARCH_VERSION 0.90.13

RUN \
  mkdir -p /opt && \
  cd /tmp && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz && \
  tar -xzf elasticsearch-$ELASTICSEARCH_VERSION.tar.gz && \
  rm -rf elasticsearch-$ELASTICSEARCH_VERSION.tar.gz && \
  mv elasticsearch-$ELASTICSEARCH_VERSION /opt/elasticsearch

ADD ./config/elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml
ADD ./scripts/start.sh /start.sh

VOLUME ["/data"]

EXPOSE 9200
EXPOSE 9300

CMD ["/start.sh"]
