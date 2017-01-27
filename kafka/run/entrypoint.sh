#!/bin/bash

# figure out the group id of mounted volume
# and write in that folder as a user from that
# group so it can be deleted from host side
TARGET_GID=$(stat -c "%g" /data)
TARGET_UID=$(stat -c "%u" /data)
GRP_EXISTS=$(cat /etc/group | grep $TARGET_GID | wc -l)

if [ "$TARGET_GID" == "0" ] && [ "$TARGET_UID" == "0" ]; then

    /opt/kafka-server

else
    # Create new group using target GID and add nobody user
    if [ $GRP_EXISTS == "0" ]; then
        addgroup -g $TARGET_GID tempgroup
        adduser -G tempgroup -u $TARGET_UID -D -H -s /bin/ash tmpusr
    else
        # GID exists, find group name and add
        GROUP=$(getent group $TARGET_GID | cut -d: -f1)
        adduser -G $GROUP -u $TARGET_UID -D -H -s /bin/ash tmpusr
    fi
    su -c "/opt/kafka-server" -s /bin/bash tmpusr
fi