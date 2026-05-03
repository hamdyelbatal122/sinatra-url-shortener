require 'sinatra'
require 'json'

get '/api/docs' do
  content_type :json
  {
    openapi: '3.0.0',
    info: {
      title: 'Sinatra URL Shortener API',
      version: '1.0.0',
      description: 'A professional URL shortener API with authentication, analytics, and management features.',
      contact: {
        name: 'API Support',
        url: 'https://github.com/hamdyelbatal122/Sinatra'
      }
    },
    servers: [
      { url: ENV.fetch('APP_URL', 'http://localhost:4567'), description: 'Production' }
    ],
    paths: {
      '/api/links': {
        get: {
          tags: ['Links'],
          summary: 'List all links',
          description: 'Returns a list of all shortened links ordered by hit count',
          responses: {
            '200': {
              description: 'Links retrieved successfully',
              content: {
                'application/json': {
                  schema: {
                    type: 'array',
                    items: {
                      type: 'object',
                      properties: {
                        id: { type: 'integer' },
                        name: { type: 'string' },
                        url: { type: 'string' },
                        hits: { type: 'integer' },
                        category: { type: 'string' },
                        tags: { type: 'string' }
                      }
                    }
                  }
                }
              }
            }
          }
        },
        post: {
          tags: ['Links'],
          summary: 'Create a new link',
          description: 'Creates a new shortened link (admin only)',
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    name: { type: 'string', description: 'Unique name for the link' },
                    url: { type: 'string', description: 'Target URL' },
                    category: { type: 'string', description: 'Optional category' },
                    tags: { type: 'string', description: 'Comma-separated tags' }
                  },
                  required: ['name', 'url']
                }
              }
            }
          },
          responses: {
            '200': {
              description: 'Link created successfully',
              content: {
                'application/json': {
                  schema: {
                    type: 'object',
                    properties: {
                      id: { type: 'integer' },
                      name: { type: 'string' },
                      url: { type: 'string' },
                      hits: { type: 'integer' }
                    }
                  }
                }
              }
            },
            '403': { description: 'Forbidden - admin access required' }
          }
        }
      },
      '/api/links/{id}': {
        get: {
          tags: ['Links'],
          summary: 'Get a specific link',
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': {
              description: 'Link retrieved successfully',
              content: {
                'application/json': {
                  schema: {
                    type: 'object',
                    properties: {
                      id: { type: 'integer' },
                      name: { type: 'string' },
                      url: { type: 'string' },
                      hits: { type: 'integer' }
                    }
                  }
                }
              }
            },
            '404': { description: 'Link not found' }
          }
        },
        delete: {
          tags: ['Links'],
          summary: 'Delete a link',
          description: 'Deletes a shortened link (admin only)',
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': {
              description: 'Link deleted successfully',
              content: {
                'application/json': {
                  schema: {
                    type: 'object',
                    properties: {
                      status: { type: 'string' }
                    }
                  }
                }
              }
            },
            '403': { description: 'Forbidden - admin access required' },
            '404': { description: 'Link not found' }
          }
        }
      }
    },
    components: {
      schemas: {
        Link: {
          type: 'object',
          properties: {
            id: { type: 'integer' },
            name: { type: 'string' },
            url: { type: 'string' },
            category: { type: 'string' },
            tags: { type: 'string' },
            hits: { type: 'integer' },
            created_at: { type: 'string', format: 'date-time' }
          }
        },
        Error: {
          type: 'object',
          properties: {
            error: { type: 'string' },
            message: { type: 'string' }
          }
        }
      }
    }
  }.to_json
end

get '/api/docs/ui' do
  erb :api_docs
end
