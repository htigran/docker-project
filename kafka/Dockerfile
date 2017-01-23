# HBase in Docker

FROM openjdk:8-jre-alpine

MAINTAINER Tigran Hovhannisyan <tigran.hovhannisyan@intel.com>

COPY build/* /build/

ENV SCALA_VERSION 2.11
ENV KAFKA_VERSION 0.10.1.0

RUN /build/prepare.sh && \
    cd /opt/kafka && /build/build.sh \
    cd / && /build/cleanup.sh && rm -rf /build

VOLUME /data

#ADD ./conf/* /opt/kafka/config/
ADD ./run/* /opt/

ENV KAFKA_HOME /opt/kafka

# BROKER
EXPOSE 9092

ENTRYPOINT ["/opt/entrypoint.sh"]
