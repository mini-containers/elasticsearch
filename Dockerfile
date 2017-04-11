FROM alpine:3.5

ENV JAVA_VERSION 8.121.13-r0

RUN apk add --no-cache openjdk8-jre-base=$JAVA_VERSION pwgen

ENV ELASTICSEARCH_VERSION 5.3.0

RUN \
  apk add --no-cache --virtual .install-tools wget && \
  mkdir -p /opt && \
  cd /tmp && \
  wget --progress=dot:mega https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz && \
  tar -xzf elasticsearch-$ELASTICSEARCH_VERSION.tar.gz && \
  rm -rf elasticsearch-$ELASTICSEARCH_VERSION.tar.gz && \
  mv elasticsearch-$ELASTICSEARCH_VERSION /opt/elasticsearch && \
  apk del .install-tools

COPY ./config/elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml
COPY ./scripts/start.sh /start.sh

VOLUME ["/data"]

EXPOSE 9200
EXPOSE 9300

CMD ["/start.sh"]
