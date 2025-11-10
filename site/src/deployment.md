# Deployment

This project is deployed on Cloudflare with multiple components:

## Components

1. **Neo4j Container** - Self-hosted Neo4j with GDS
2. **AI Chatbot Worker** - Cloudflare Worker with AI SDK
3. **Static Site** - Lumadoc-generated static site

## CI/CD

The GitHub Actions workflow automatically:

- Builds and deploys Neo4j container
- Deploys Cloudflare Worker
- Builds and deploys static site to Cloudflare Pages

## Environment Variables

Configure the following in Cloudflare:

- `CLOUDFLARE_ACCOUNT_ID`
- `CLOUDFLARE_API_TOKEN`
- `NEO4J_URI` (for Worker connection to Neo4j)
- `NEO4J_USER`
- `NEO4J_PASSWORD`

## Manual Deployment

### Worker

```bash
cd worker
npm install
npm run deploy
```

### Static Site

```bash
cd site
npm install
npm run build
# Deploy dist/ to Cloudflare Pages
```

