FROM gliderlabs/alpine:3.3

ENV JAVA_VERSION 8.77.03-r0

RUN apk add --no-cache openjdk8-jre-base=$JAVA_VERSION pwgen

ENV ELASTICSEARCH_VERSION 1.7.5

RUN \
  apk add --no-cache --virtual .install-tools wget && \
  mkdir -p /opt && \
  cd /tmp && \
  wget --progress=dot:mega https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz && \
  tar -xzf elasticsearch-$ELASTICSEARCH_VERSION.tar.gz && \
  rm -rf elasticsearch-$ELASTICSEARCH_VERSION.tar.gz && \
  mv elasticsearch-$ELASTICSEARCH_VERSION /opt/elasticsearch && \
  apk del --virtual .install-tools

ENV ES_HTTP_BASIC_VERSION 1.5.1

RUN \
  /opt/elasticsearch/bin/plugin --install http-basic --url https://github.com/Asquera/elasticsearch-http-basic/releases/download/v$ES_HTTP_BASIC_VERSION/elasticsearch-http-basic-$ES_HTTP_BASIC_VERSION.jar

COPY ./config/elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml
COPY ./scripts/start.sh /start.sh

VOLUME ["/data"]

EXPOSE 9200
EXPOSE 9300

CMD ["/start.sh"]
