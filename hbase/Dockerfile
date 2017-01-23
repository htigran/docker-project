# HBase in Docker

FROM openjdk:8-jre-alpine

MAINTAINER Tigran Hovhannisyan <tigran.hovhannisyan@intel.com>

COPY build/* /build/

ENV HBASE_VERSION 1.2.4

RUN /build/prepare.sh && \
    cd /opt/hbase && /build/build.sh \
    cd / && /build/cleanup.sh && rm -rf /build

VOLUME /data

ADD ./conf/* /opt/hbase/conf/

ADD ./run/* /opt/

# REST API
EXPOSE 8080

# REST Web UI at :8085/rest.jsp
EXPOSE 8085

# Thrift API
EXPOSE 9090

# Thrift Web UI at :9095/thrift.jsp
EXPOSE 9095

# HBase's Embedded zookeeper cluster
EXPOSE 2181

# HBase Master web UI at :16010/master-status;  ZK at :16010/zk.jsp
EXPOSE 16010

ENTRYPOINT ["/opt/entrypoint.sh"]
