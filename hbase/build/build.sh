#!/bin/ash

. /build/config.sh

here=$(pwd)

# delete files that are not needed to run hbase
rm -rf docs *.txt LEGAL
rm -f */*.cmd

# Set Java home for hbase servers
sed -i "s,^. export JAVA_HOME.*,export JAVA_HOME=$JAVA_HOME," conf/hbase-env.sh

cd /usr/bin
ln -sf $here/bin/* .
