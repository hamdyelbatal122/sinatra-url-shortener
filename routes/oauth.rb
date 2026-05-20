require 'sinatra'
require 'omniauth'
require 'omniauth-google-oauth2'
require 'omniauth-github'

use OmniAuth::Builder do
  provider :google_oauth2,
    ENV.fetch('GOOGLE_CLIENT_ID', ''),
    ENV.fetch('GOOGLE_CLIENT_SECRET', ''),
    scope: ['email', 'profile']

  provider :github,
    ENV.fetch('GITHUB_CLIENT_ID', ''),
    ENV.fetch('GITHUB_CLIENT_SECRET', ''),
    scope: 'user:email'
end

get '/auth/:provider/callback' do
  auth = request.env['omniauth.auth']
  provider = params[:provider]

  oauth_provider = OAuthProvider.first(provider: provider, uid: auth['uid'].to_s)

  if oauth_provider
    session[:user_id] = oauth_provider.user_id
    redirect '/'
  else
    email = auth['info']['email']
    name = auth['info']['name']

    user = User.first(email: email)
    unless user
      base_username = name ? name.downcase.gsub(/[^a-z0-9]/, '') : email.split('@').first
      username = base_username
      counter = 1
      while User.first(username: username)
        username = "#{base_username}#{counter}"
        counter += 1
      end

      user = User.create(
        username: username,
        email: email,
        role: 'editor',
        email_notifications_enabled: true
      )
    end

    OAuthProvider.create(
      user_id: user.id,
      provider: provider,
      uid: auth['uid'].to_s,
      email: email,
      name: name
    )

    session[:user_id] = user.id
    redirect '/'
  end
end

get '/auth/failure' do
  @error = params[:message] || 'Authentication failed'
  erb :login
end

get '/auth/disconnect/:provider' do
  authenticate!
  provider = params[:provider]
  oauth_provider = OAuthProvider.first(user_id: current_user.id, provider: provider)
  oauth_provider.destroy if oauth_provider
  redirect '/settings'
end
