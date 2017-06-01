#!/usr/bin/env bash

set -e

if [ -v ES_NETWORK_PUBLISH_HOST_DETECT_REGEXP ]; then
    IP=$(ip addr | awk -F"[ /]*" "/${ES_NETWORK_PUBLISH_HOST_DETECT_REGEXP}/{print \$3}")
    if [ -z $IP ]; then
        (>&2 echo "Unable to detect publish ip with regexp "$ES_NETWORK_PUBLISH_HOST_DETECT_REGEXP)
        exit 1
    else
        echo "Detected publish ip "$IP
        env network.publish_host=$IP > /dev/null
    fi
fi

exec bin/es-docker "$@"
