# AI Chatbot

The LiteIP Graph project includes an AI-powered chatbot built with Cloudflare Workers and the Cloudflare AI SDK.

## Features

- Conversational AI powered by Cloudflare's AI models
- Context-aware responses about graph databases and Neo4j
- Fast, edge-deployed responses via Cloudflare Workers

## Usage

The chatbot is accessible via the Cloudflare Worker endpoint. You can integrate it into your application or use it directly via API.

### API Endpoint

```
POST https://your-worker.workers.dev
Content-Type: application/json

{
  "message": "What is Graph Data Science?",
  "conversation": []
}
```

### Response Format

```json
{
  "response": "Graph Data Science is...",
  "conversation": [...]
}
```

## Integration

To integrate the chatbot into your static site, add the following JavaScript:

```javascript
async function sendMessage(message) {
  const response = await fetch('https://your-worker.workers.dev', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ message }),
  });
  const data = await response.json();
  return data.response;
}
```

