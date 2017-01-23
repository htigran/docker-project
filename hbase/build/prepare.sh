#!/bin/ash

. /build/config.sh

apk add --update $BUILD_PACKAGES $RUN_PACKAGES

mkdir /opt && cd /opt

curl -SL $HBASE_DIST/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz | tar -x -z && mv hbase-${HBASE_VERSION} hbase

mkdir -m 777 /opt/hbase/logs