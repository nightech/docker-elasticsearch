#!/usr/bin/env bash

set -e

declare -A ENV_CONFIG=()

ENV_CONFIG[ES_CLUSTER_NAME]=${ES_CLUSTER_NAME:-"null"}
ENV_CONFIG[ES_NODE_NAME]=${ES_NODE_NAME:-"null"}
ENV_CONFIG[ES_NETWORK_PUBLISH_HOST]=${ES_NETWORK_PUBLISH_HOST:-"null"}
ENV_CONFIG[ES_ZEN_MINIMUM_MASTER]=${ES_ZEN_MINIMUM_MASTER:-"1"}
ENV_CONFIG[ES_ZEN_PING_UNICAST_HOSTS]=${ES_ZEN_PING_UNICAST_HOSTS:-"null"}
ENV_CONFIG[ES_CORS_ENABLED]=${ES_CORS_ENABLED:-"true"}
ENV_CONFIG[ES_CORS_ORIGIN]=${ES_CORS_ORIGIN:-"*"}

if [ -v ES_NETWORK_PUBLISH_HOST_DETECT_REGEXP ]; then
    IP=$(ip addr | awk -F"[ /]*" "/${ES_NETWORK_PUBLISH_HOST_DETECT_REGEXP}/{print \$3}")
    if [ -z $IP ]; then
        (>&2 echo "Unable to detect publish ip with regexp "$ES_NETWORK_PUBLISH_HOST_DETECT_REGEXP)
        exit 1
    else
        echo "Detected publish ip "$IP
    fi

    ENV_CONFIG[ES_NETWORK_PUBLISH_HOST]=$IP
fi

for KEY in "${!ENV_CONFIG[@]}"
do
    # echo "Configuration : \$"$KEY" set to "${ENV_CONFIG[$KEY]}
    sed -i.bak "s!\%"$KEY"\%!"${ENV_CONFIG[$KEY]}"!" /usr/share/elasticsearch/config/elasticsearch.yml
done


rm /usr/share/elasticsearch/config/elasticsearch.yml.bak

/docker-entrypoint.sh "$@"
