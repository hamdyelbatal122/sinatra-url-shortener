require 'sinatra'
require 'json'
require_relative '../models/link'

# Pure-Ruby LIKE pattern escape (%, _, \) — no Sequel extension needed
def sql_like_escape(str)
  str.gsub(/[%_\\]/) { |c| "\\#{c}" }
end

get '/' do
  @links = Link.order(Sequel.desc(:hits)).all
  erb :index
end

get '/links' do
  redirect '/'
end

post '/links' do
  authenticate!
  halt 403 unless can_manage_links?
  begin
    name = InputValidation.sanitize_string(params[:name])
    url = InputValidation.sanitize_string(params[:url])

    halt 400, 'Invalid URL format' unless InputValidation.validate_url(url)
    halt 400, 'Link name cannot be empty' if name.empty?

    link = Link.create(
      name: name,
      url: url,
      category: InputValidation.sanitize_string(params[:category]),
      tags: InputValidation.sanitize_string(params[:tags])
    )
    log_audit('create', 'Link', link.id, "Created link #{link.name}")
    EmailService.send_link_created_notification(current_user, link)
    redirect '/'
  rescue Sequel::ValidationFailed, Sequel::DatabaseError => e
    halt 400, "Error: #{e.message}"
  end
end

get '/links/suggest' do
  query = params[:q]
  escaped = sql_like_escape(query.to_s)
  results = Link.where(Sequel.like(:name, "#{escaped}%")).or(Sequel.like(:url, "%#{escaped}%"))
  results = results.all.map(&:name)
  content_type :json
  [query, results].to_json
end

get '/links/search' do
  query = params[:q].to_s.strip
  category = params[:category].to_s.strip
  tag = params[:tag].to_s.strip

  link  = Link[name: query]
  if link
    redirect "/#{link.name}"
  else
    dataset = Link.dataset

    unless query.empty?
      escaped_query = sql_like_escape(query)
      dataset = dataset.where(Sequel.like(:name, "%#{escaped_query}%")).or(Sequel.like(:url, "%#{escaped_query}%"))
    end

    unless category.empty?
      escaped_category = sql_like_escape(category)
      dataset = dataset.where(Sequel.like(:category, "%#{escaped_category}%"))
    end

    unless tag.empty?
      escaped_tag = sql_like_escape(tag)
      dataset = dataset.where(Sequel.like(:tags, "%#{escaped_tag}%"))
    end

    @links = dataset.order(Sequel.desc(:hits)).all
    erb :index
  end
end

get '/links/opensearch.xml' do
  content_type :xml
  erb :opensearch, layout: false
end

get '/links/:id/remove' do
  authenticate!
  halt 403 unless admin?
  link = Link.find(id: params[:id])
  halt 404 unless link
  link_name = link.name
  log_audit('delete', 'Link', link.id, "Deleted link #{link.name}")
  EmailService.send_link_deleted_notification(current_user, link_name)
  link.destroy
  redirect '/'
end

get '/:name/?*?' do
  link = Link[name: params[:name]]
  halt 404 unless link
  link.hit!
  parts = (params[:splat].first || '').split('/')
  url = link.url
  url %= parts if parts.any?
  redirect url
end
