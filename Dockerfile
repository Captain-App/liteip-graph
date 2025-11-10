FROM neo4j:5-community

# Set Neo4j environment variables
ENV NEO4J_AUTH=neo4j/change-password
ENV NEO4J_PLUGINS='["apoc"]'
ENV NEO4J_dbms_security_procedures_unrestricted=apoc.*

# Memory settings (adjust based on container resources)
ENV NEO4J_dbms_memory_heap_initial__size=512m
ENV NEO4J_dbms_memory_heap_max__size=2G
ENV NEO4J_dbms_memory_pagecache_size=1G

# Network settings
ENV NEO4J_dbms_default__listen__address=0.0.0.0
ENV NEO4J_dbms_connector_http_enabled=true
ENV NEO4J_dbms_connector_http_listen__address=:7474
ENV NEO4J_dbms_connector_bolt_enabled=true
ENV NEO4J_dbms_connector_bolt_listen__address=:7687

# Copy custom Neo4j configuration (mounted as volume in docker-compose)
# For direct docker run, mount: -v $(pwd)/neo4j.conf:/etc/neo4j/neo4j.conf
COPY neo4j.conf /etc/neo4j/neo4j.conf

# Expose Neo4j ports
# 7474: HTTP (Neo4j Browser)
# 7687: Bolt (Application connections)
EXPOSE 7474 7687

# Neo4j image already has the correct entrypoint
# This container will run Neo4j as a long-lived service

