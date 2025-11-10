export interface Env {
  AI: any; // Cloudflare AI binding
  NEO4J_URI?: string;
  NEO4J_USER?: string;
  NEO4J_PASSWORD?: string;
}

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    // Handle CORS preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, {
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type',
        },
      });
    }

    // Only allow POST requests for chat
    if (request.method !== 'POST') {
      return new Response('Method not allowed', { status: 405 });
    }

    try {
      const { message, conversation = [] } = await request.json<{
        message: string;
        conversation?: Array<{ role: string; content: string }>;
      }>();

      if (!message) {
        return new Response(JSON.stringify({ error: 'Message is required' }), {
          status: 400,
          headers: { 'Content-Type': 'application/json' },
        });
      }

      // Build conversation context
      const messages = [
        {
          role: 'system',
          content: 'You are a helpful AI assistant that can answer questions about graph databases, Neo4j, and Graph Data Science. Be concise and helpful.',
        },
        ...conversation,
        { role: 'user', content: message },
      ];

      // Generate response using Cloudflare AI
      const response = await env.AI.run('@cf/meta/llama-3-8b-instruct', {
        messages,
        max_tokens: 512,
      });

      const responseText = typeof response === 'string' ? response : response.response || JSON.stringify(response);

      return new Response(
        JSON.stringify({
          response: responseText,
          conversation: [...messages, { role: 'assistant', content: responseText }],
        }),
        {
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          },
        }
      );
    } catch (error) {
      console.error('Error processing request:', error);
      return new Response(
        JSON.stringify({ error: 'Internal server error', details: error instanceof Error ? error.message : 'Unknown error' }),
        {
          status: 500,
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          },
        }
      );
    }
  },
};

