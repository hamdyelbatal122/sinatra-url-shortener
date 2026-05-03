require 'rails_helper'

describe 'Sinatra URL Shortener API', type: :request do
  path '/api/links' do
    get 'List all links' do
      tags 'Links'
      produces 'application/json'
      description 'Returns a list of all shortened links ordered by hit count'

      response '200', 'Links retrieved successfully' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   url: { type: :string },
                   hits: { type: :integer }
                 }
               }
        run_test!
      end
    end

    post 'Create a new link' do
      tags 'Links'
      security [{ bearer_auth: [] }]
      consumes 'application/json'
      produces 'application/json'
      description 'Creates a new shortened link (admin only)'

      parameter name: :link, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, description: 'Unique name for the link' },
          url: { type: :string, description: 'Target URL' },
          category: { type: :string, description: 'Optional category' },
          tags: { type: :string, description: 'Comma-separated tags' }
        },
        required: ['name', 'url']
      }

      response '200', 'Link created successfully' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 url: { type: :string },
                 hits: { type: :integer }
               }
        run_test!
      end

      response '403', 'Forbidden - admin access required' do
        run_test!
      end
    end
  end

  path '/api/links/{id}' do
    get 'Get a specific link' do
      tags 'Links'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'Link ID'

      response '200', 'Link retrieved successfully' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 url: { type: :string },
                 hits: { type: :integer }
               }
        run_test!
      end

      response '404', 'Link not found' do
        run_test!
      end
    end

    delete 'Delete a link' do
      tags 'Links'
      security [{ bearer_auth: [] }]
      parameter name: :id, in: :path, type: :integer, description: 'Link ID'
      description 'Deletes a shortened link (admin only)'

      response '200', 'Link deleted successfully' do
        schema type: :object,
               properties: {
                 status: { type: :string }
               }
        run_test!
      end

      response '403', 'Forbidden - admin access required' do
        run_test!
      end

      response '404', 'Link not found' do
        run_test!
      end
    end
  end
end
