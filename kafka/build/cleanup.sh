#!/bin/ash

. /build/config.sh

apk del $BUILD_PACKAGES

rm -rf /var/cache/apk/*

