require 'sinatra'
require 'json'
require_relative '../models/link'

before '/api/*' do
  content_type :json
end

# Create a new short link (Admin/Editor)
post '/api/links' do
  authenticate!
  halt 403, { error: 'Forbidden' }.to_json unless can_manage_links?
  
  begin
    body = request.body.read
    halt 400, { error: 'Empty request body' }.to_json if body.empty?
    data = JSON.parse(body)
    
    link = Link.create(
      name: data['name'], 
      url: data['url'],
      category: data['category'],
      tags: data['tags']
    )
    { id: link.id, name: link.name, url: link.url, hits: link.hits, category: link.category, tags: link.tags }.to_json
  rescue JSON::ParserError
    halt 400, { error: 'Invalid JSON' }.to_json
  rescue Sequel::ValidationFailed, Sequel::DatabaseError => e
    halt 400, { error: e.message }.to_json
  end
end

# List all links
get '/api/links' do
  links = Link.order(Sequel.desc(:hits)).all.map do |l| 
    { id: l.id, name: l.name, url: l.url, hits: l.hits, category: l.category, tags: l.tags }
  end
  links.to_json
end

# Get a single link
get '/api/links/:id' do
  link = Link[params[:id]]
  halt 404, { error: 'Link not found' }.to_json unless link
  { id: link.id, name: link.name, url: link.url, hits: link.hits, category: link.category, tags: link.tags }.to_json
end

# Delete a link (admin only)
delete '/api/links/:id' do
  authenticate!
  halt 403, { error: 'Forbidden' }.to_json unless admin?
  link = Link[params[:id]]
  halt 404, { error: 'Link not found' }.to_json unless link
  link.destroy
  { status: 'deleted' }.to_json
end
