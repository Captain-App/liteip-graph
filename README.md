# liteip-graph

Long-lived Neo4j container with support for Neo4j Aura connections.

## Features

- Neo4j 5 Community Edition with APOC plugin
- Long-lived container deployment
- Support for connecting to Neo4j Aura cloud instances
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

### Connecting to Neo4j Aura

If you want to connect your application to a Neo4j Aura instance instead of the local container:

1. Get your Aura connection URI from the Neo4j Aura dashboard
2. Update your application configuration with:
   - `NEO4J_AURA_URI`: Your Aura instance URI (format: `neo4j+s://xxxxx.databases.neo4j.io`)
   - `NEO4J_AURA_USER`: Your Aura username
   - `NEO4J_AURA_PASSWORD`: Your Aura password

### CI/CD

The GitHub Actions workflow will:
- Build Docker images on every push and pull request
- Push images to Cloudflare Container Registry on pushes to main/develop branches
- Deploy Neo4j container to Cloudflare Workers for Platforms

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
- Memory allocation (heap and page cache)
- Network bindings
- Security settings
- APOC plugin configuration

### Environment Variables

See `env.example` for available environment variables:
- `NEO4J_AUTH`: Neo4j authentication (format: `username/password`)
- `NEO4J_PLUGINS`: Comma-separated list of plugins to enable
- Aura connection variables (if using Aura cloud)

## Production Deployment

1. Update `neo4j.conf` with production-appropriate memory settings
2. Set strong passwords via `NEO4J_AUTH` environment variable
3. Configure persistent volumes for data, logs, and imports
4. Set up monitoring and backup strategies
5. Configure Cloudflare deployment in the GitHub Actions workflow

## Next Steps

1. Update Neo4j credentials in production deployments
2. Configure persistent storage volumes for data persistence
3. Set up backup strategies for Neo4j data
4. Add application code that connects to Neo4j
5. Configure Cloudflare deployment commands in the CI/CD workflow

