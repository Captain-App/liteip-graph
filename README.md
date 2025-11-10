# liteip-graph

Self-hosted Neo4j with Graph Data Science (GDS) library on Cloudflare.

## Features

- Neo4j 5 Community Edition
- Graph Data Science (GDS) library for graph algorithms and analytics
- APOC plugin for extended functionality
- Long-lived container deployment optimized for Cloudflare
- Docker Compose setup for local development
- CI/CD pipeline for Cloudflare container hosting

## Setup

### Prerequisites

- Docker and Docker Compose
- GitHub Actions secrets configured:
  - `CLOUDFLARE_ACCOUNT_ID`: Your Cloudflare Account ID
  - `CLOUDFLARE_API_TOKEN`: Cloudflare API token with container registry permissions

### GitHub Secrets Configuration

1. Go to your repository settings: `https://github.com/Captain-App/liteip-graph/settings/secrets/actions`
2. Add the following secrets:
   - `CLOUDFLARE_ACCOUNT_ID`: Your Cloudflare Account ID (found in Cloudflare dashboard)
   - `CLOUDFLARE_API_TOKEN`: A Cloudflare API token with:
     - `Account:Cloudflare Workers:Edit` permission
     - `Zone:Zone:Read` permission (if using zones)
     - `Account:Workers Scripts:Edit` permission

### Cloudflare Container Registry Setup

1. Enable Workers for Platforms in your Cloudflare dashboard
2. Create a namespace for your containers (if needed)
3. Ensure your API token has container registry access

### Local Development

#### Using Docker Compose (Recommended)

```bash
# Copy environment file
cp env.example .env

# Edit .env with your Neo4j credentials
# Then start Neo4j
docker-compose up -d

# Check logs
docker-compose logs -f neo4j

# Access Neo4j Browser
open http://localhost:7474
```

#### Using Docker directly

```bash
# Build the container
docker build -t liteip-graph .

# Run the container
docker run -d \
  --name liteip-graph-neo4j \
  -p 7474:7474 \
  -p 7687:7687 \
  -e NEO4J_AUTH=neo4j/your-password \
  liteip-graph
```

### Connecting to Neo4j

- **HTTP**: http://localhost:7474 (Neo4j Browser)
- **Bolt**: bolt://localhost:7687 (Application connections)

Default credentials:
- Username: `neo4j`
- Password: `change-password` (change this in production!)

### Verifying GDS Installation

After starting the container, verify that GDS is installed and working:

```bash
# Using cypher-shell
cypher-shell -u neo4j -p change-password

# In the Cypher shell, run:
CALL gds.version() YIELD version RETURN version;

# List available GDS procedures:
CALL gds.list() YIELD name, description RETURN name, description;
```

Or in Neo4j Browser (http://localhost:7474):
```cypher
CALL gds.version() YIELD version RETURN version;
```

### CI/CD

The GitHub Actions workflow will:
- Build Docker images with Neo4j + GDS on every push and pull request
- Push images to Cloudflare Container Registry on pushes to main/develop branches
- Deploy Neo4j + GDS container to Cloudflare Workers for Platforms

### Graph Data Science (GDS)

This setup includes Neo4j Graph Data Science library (Community Edition), which provides:
- **Graph Algorithms**: PageRank, Centrality, Community Detection, Similarity, Path Finding
- **Graph Embeddings**: Node2Vec, FastRP, GraphSAGE
- **Machine Learning**: Link Prediction, Node Classification
- **Graph Projections**: In-memory graph projections for fast algorithm execution

Example usage:
```cypher
// Create a graph projection
CALL gds.graph.project(
  'myGraph',
  'Node',
  'RELATES_TO'
);

// Run PageRank algorithm
CALL gds.pageRank.stream('myGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS name, score
ORDER BY score DESC;
```

## Project Structure

```
.
├── .github/
│   └── workflows/
│       └── ci-cd.yml      # GitHub Actions CI/CD workflow
├── Dockerfile             # Neo4j container definition
├── docker-compose.yml     # Local development setup
├── neo4j.conf            # Neo4j configuration
├── env.example           # Environment variables template
├── .dockerignore         # Files to exclude from Docker build
├── .gitignore           # Git ignore rules
└── README.md            # This file
```

## Configuration

### Neo4j Configuration

The `neo4j.conf` file contains custom Neo4j settings:
- Memory allocation (heap and page cache) - increased for GDS operations
- Network bindings
- Security settings
- APOC and GDS plugin configuration
- GDS-specific memory settings

### Environment Variables

See `env.example` for available environment variables:
- `NEO4J_AUTH`: Neo4j authentication (format: `username/password`)
- `NEO4J_PLUGINS`: JSON array of plugins (includes `apoc` and `graph-data-science`)
- `NEO4J_gds_enterprise__license__accept`: Set to `yes` to accept GDS license
- `NEO4J_gds_edition`: Set to `community` for Community Edition features

### Memory Requirements

GDS requires additional memory for graph algorithm execution:
- **Heap**: 1-4GB (configurable via `NEO4J_dbms_memory_heap_max__size`)
- **Page Cache**: 2GB+ (configurable via `NEO4J_dbms_memory_pagecache_size`)
- **GDS Off-Heap**: 2GB+ (configurable via `gds.memory.off_heap.max_size` in `neo4j.conf`)

Adjust these settings based on your graph size and algorithm requirements.

## Production Deployment on Cloudflare

1. **Memory Configuration**: Update `neo4j.conf` with production-appropriate memory settings based on your graph size
2. **Security**: Set strong passwords via `NEO4J_AUTH` environment variable
3. **Persistent Storage**: Configure persistent volumes for data, logs, and imports in Cloudflare
4. **GDS License**: Ensure `NEO4J_gds_enterprise__license__accept=yes` is set (required for GDS)
5. **Monitoring**: Set up monitoring for Neo4j and GDS operations
6. **Backup**: Configure backup strategies for Neo4j data
7. **Deployment**: Configure Cloudflare deployment commands in the GitHub Actions workflow

### Cloudflare-Specific Considerations

- Ensure your Cloudflare container runtime has sufficient memory (4GB+ recommended for GDS)
- Configure persistent volumes for Neo4j data directory
- Set up health checks using the GDS health check in `docker-compose.yml`
- Monitor GDS memory usage and adjust `gds.memory.off_heap.max_size` as needed

## Next Steps

1. Update Neo4j credentials in production deployments
2. Configure persistent storage volumes for data persistence on Cloudflare
3. Set up backup strategies for Neo4j data
4. Add application code that uses Neo4j and GDS algorithms
5. Configure Cloudflare deployment commands in the CI/CD workflow
6. Test GDS algorithms with your graph data
7. Monitor performance and adjust memory settings as needed

