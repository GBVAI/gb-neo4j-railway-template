# syntax=docker/dockerfile:1.7

ARG RAILWAY_NEO4J_IMAGE_TAG=5.26.22-community-trixie
FROM neo4j:${RAILWAY_NEO4J_IMAGE_TAG}

USER root

COPY scripts/entrypoint.sh /startup/railway-entrypoint.sh
COPY scripts/healthcheck.sh /startup/railway-healthcheck.sh

RUN chmod 0755 /startup/railway-entrypoint.sh /startup/railway-healthcheck.sh

ENV NEO4J_server_http_enabled=true \
    NEO4J_server_https_enabled=false \
    NEO4J_server_bolt_enabled=true \
    NEO4J_server_memory_heap_initial__size=1G \
    NEO4J_server_memory_heap_max__size=4G \
    NEO4J_server_memory_pagecache_size=4G \
    NEO4J_dbms_memory_transaction_total_max=1G

ENTRYPOINT ["/startup/railway-entrypoint.sh"]
CMD ["neo4j"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=45s --retries=10 CMD ["/startup/railway-healthcheck.sh"]
