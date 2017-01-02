FROM elasticsearch:2.4

COPY ./overlay/ /

HEALTHCHECK --interval=30s --retries=3 --timeout=5s CMD curl -s 127.0.0.1:9200 | grep -q number || exit 1

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["elasticsearch"]
