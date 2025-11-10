FROM neo4j:5-community

# Set Neo4j version for GDS compatibility
ARG NEO4J_VERSION=5.15.0
ARG GDS_VERSION=2.6.8

# Set Neo4j environment variables
ENV NEO4J_AUTH=neo4j/change-password
ENV NEO4J_PLUGINS='["apoc", "graph-data-science"]'
ENV NEO4J_dbms_security_procedures_unrestricted=apoc.*,gds.*

# Memory settings (adjust based on container resources)
# GDS requires additional memory for graph algorithms
ENV NEO4J_dbms_memory_heap_initial__size=1G
ENV NEO4J_dbms_memory_heap_max__size=4G
ENV NEO4J_dbms_memory_pagecache_size=2G

# Network settings
ENV NEO4J_dbms_default__listen__address=0.0.0.0
ENV NEO4J_dbms_connector_http_enabled=true
ENV NEO4J_dbms_connector_http_listen__address=:7474
ENV NEO4J_dbms_connector_bolt_enabled=true
ENV NEO4J_dbms_connector_bolt_listen__address=:7687

# GDS configuration
ENV NEO4J_gds_enterprise__license__accept=yes
ENV NEO4J_gds_edition=community

# Install Graph Data Science plugin
# Neo4j image is based on Debian, wget should be available
RUN apt-get update && apt-get install -y --no-install-recommends wget && \
    wget -O /tmp/neo4j-graph-data-science-${GDS_VERSION}.jar \
    https://github.com/neo4j/graph-data-science/releases/download/${GDS_VERSION}/neo4j-graph-data-science-${GDS_VERSION}.jar && \
    mv /tmp/neo4j-graph-data-science-${GDS_VERSION}.jar /var/lib/neo4j/plugins/ && \
    chown neo4j:neo4j /var/lib/neo4j/plugins/neo4j-graph-data-science-${GDS_VERSION}.jar && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Copy custom Neo4j configuration
COPY neo4j.conf /etc/neo4j/neo4j.conf

# Expose Neo4j ports
# 7474: HTTP (Neo4j Browser)
# 7687: Bolt (Application connections)
EXPOSE 7474 7687

# Neo4j image already has the correct entrypoint
# This container will run Neo4j with GDS as a long-lived service

