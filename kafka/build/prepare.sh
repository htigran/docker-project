#!/bin/ash

. /build/config.sh

apk add --update $BUILD_PACKAGES $RUN_PACKAGES

mkdir /opt && cd /opt

MIRROR=$(curl --stderr /dev/null https://www.apache.org/dyn/closer.cgi\?as_json\=1 | jq -r '.preferred')

curl -SL ${MIRROR}kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz | tar -x -z && mv kafka_"$SCALA_VERSION"-"$KAFKA_VERSION" kafka

mkdir -m 777 /opt/kafka/logs
chmod a+rw /opt/kafka/config -R