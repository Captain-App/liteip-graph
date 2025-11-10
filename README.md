# liteip-graph

## Setup

### Prerequisites

- Docker
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

```bash
# Build the container
docker build -t liteip-graph .

# Run the container
docker run -p 8080:8080 liteip-graph
```

### CI/CD

The GitHub Actions workflow will:
- Build Docker images on every push and pull request
- Push images to Cloudflare Container Registry on pushes to main/develop branches
- Deploy to Cloudflare Workers for Platforms

## Project Structure

```
.
├── .github/
│   └── workflows/
│       └── ci-cd.yml      # GitHub Actions CI/CD workflow
├── Dockerfile             # Container definition
├── .dockerignore          # Files to exclude from Docker build
├── .gitignore            # Git ignore rules
└── README.md             # This file
```

## Next Steps

1. Update the `Dockerfile` with your application-specific build steps
2. Configure the deployment step in `.github/workflows/ci-cd.yml` for your specific Cloudflare setup
3. Add your application code
4. Update this README with project-specific information

