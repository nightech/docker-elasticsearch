#!/usr/bin/env bash

set -e

declare -A ENV_CONFIG=()
ENV_CONFIG[ES_CORS_ENABLED]=${ES_CORS_ENABLED:-"true"}
ENV_CONFIG[ES_CORS_ORIGIN]=${ES_CORS_ORIGIN:-"*"}

for KEY in "${!ENV_CONFIG[@]}"
do
    # echo "Configuration : \$"$KEY" set to "${ENV_CONFIG[$KEY]}
    sed -i.bak "s!\%"$KEY"\%!"${ENV_CONFIG[$KEY]}"!" /usr/share/elasticsearch/config/elasticsearch.yml
done

rm /usr/share/elasticsearch/config/elasticsearch.yml.bak

/docker-entrypoint.sh "$@"
