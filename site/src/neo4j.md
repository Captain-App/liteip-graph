# Neo4j Setup

This project includes a self-hosted Neo4j instance with Graph Data Science capabilities.

## Configuration

Neo4j is configured with:

- **Memory**: 1-4GB heap, 2GB+ page cache
- **Plugins**: APOC and Graph Data Science (GDS)
- **Ports**: 7474 (HTTP), 7687 (Bolt)

## Connection

Default credentials:
- Username: `neo4j`
- Password: `change-password` (change in production!)

## Verifying Installation

Check that GDS is installed:

```cypher
CALL gds.version() YIELD version RETURN version;
```

## Graph Data Science

The GDS library provides:

- Graph algorithms (PageRank, Centrality, etc.)
- Graph embeddings
- Machine learning capabilities
- In-memory graph projections

