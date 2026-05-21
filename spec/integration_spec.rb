require_relative 'spec_helper'

describe 'Authentication' do
  describe 'POST /login' do
    before do
      create_user(username: 'admin', password: 'admin123', role: 'admin')
    end

    it 'logs in with valid credentials' do
      post '/login', username: 'admin', password: 'admin123'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_response).to be_ok
    end

    it 'rejects invalid credentials' do
      post '/login', username: 'admin', password: 'wrongpassword'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Invalid username or password')
    end

    it 'rejects non-existent user' do
      post '/login', username: 'nonexistent', password: 'password'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Invalid username or password')
    end
  end

  describe 'GET /logout' do
    it 'logs out the user' do
      create_user
      login
      get '/logout'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_response).to be_ok
    end
  end
end

describe 'Links Management' do
  before do
    @user = create_user(role: 'editor')
    login
  end

  describe 'POST /links' do
    it 'creates a new link' do
      post '/links', name: 'docs', url: 'https://hamzi.dev/docs'
      expect(last_response).to be_redirect
      expect(Link.count).to eq(1)
      expect(Link.first.name).to eq('docs')
    end

    it 'rejects invalid URL' do
      post '/links', name: 'invalid', url: 'not-a-url'
      expect(last_response.status).to eq(400)
    end

    it 'rejects empty name' do
      post '/links', name: '', url: 'https://hamzi.dev'
      expect(last_response.status).to eq(400)
    end

    it 'requires authentication' do
      get '/logout'
      post '/links', name: 'test', url: 'https://hamzi.dev'
      expect(last_response).to be_redirect
    end
  end

  describe 'GET /:name' do
    before do
      Link.create(name: 'test', url: 'https://hamzi.dev', hits: 0)
    end

    it 'redirects to the target URL' do
      get '/test'
      expect(last_response).to be_redirect
      expect(last_response.location).to include('hamzi.dev')
    end

    it 'increments hit counter' do
      link = Link.first
      expect(link.hits).to eq(0)
      get '/test'
      link.refresh
      expect(link.hits).to eq(1)
    end

    it 'returns 404 for non-existent link' do
      get '/nonexistent'
      expect(last_response.status).to eq(404)
    end
  end

  describe 'GET /links/:id/remove' do
    before do
      @link = Link.create(name: 'test', url: 'https://hamzi.dev')
      @admin = create_user(username: 'admin', role: 'admin')
    end

    it 'deletes link as admin' do
      login(username: 'admin', password: 'password123')
      get "/links/#{@link.id}/remove"
      expect(last_response).to be_redirect
      expect(Link.count).to eq(0)
    end

    it 'rejects deletion by non-admin' do
      get "/links/#{@link.id}/remove"
      expect(last_response.status).to eq(403)
      expect(Link.count).to eq(1)
    end
  end
end

describe 'API Endpoints' do
  before do
    @user = create_user(role: 'admin')
    login
    @link = Link.create(name: 'api-test', url: 'https://api.hamzi.dev', hits: 5)
  end

  describe 'GET /api/links' do
    it 'returns all links' do
      get '/api/links'
      expect(last_response).to be_ok
      expect(last_response.content_type).to include('application/json')
      data = JSON.parse(last_response.body)
      expect(data).to be_an(Array)
      expect(data.length).to eq(1)
      expect(data[0]['name']).to eq('api-test')
    end
  end

  describe 'GET /api/links/:id' do
    it 'returns link details' do
      get "/api/links/#{@link.id}"
      expect(last_response).to be_ok
      data = JSON.parse(last_response.body)
      expect(data['id']).to eq(@link.id)
      expect(data['name']).to eq('api-test')
      expect(data['hits']).to eq(5)
    end

    it 'returns 404 for non-existent link' do
      get '/api/links/999'
      expect(last_response.status).to eq(404)
    end
  end

  describe 'POST /api/links' do
    it 'creates link as admin' do
      post '/api/links', JSON.generate(name: 'new-link', url: 'https://new.hamzi.dev'),
           'CONTENT_TYPE' => 'application/json'
      expect(last_response).to be_ok
      data = JSON.parse(last_response.body)
      expect(data['name']).to eq('new-link')
    end

    it 'rejects creation by non-admin' do
      @user.update(role: 'editor')
      post '/api/links', JSON.generate(name: 'new-link', url: 'https://new.hamzi.dev'),
           'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eq(403)
    end
  end

  describe 'DELETE /api/links/:id' do
    it 'deletes link as admin' do
      delete "/api/links/#{@link.id}"
      expect(last_response).to be_ok
      expect(Link.count).to eq(0)
    end

    it 'rejects deletion by non-admin' do
      @user.update(role: 'reader')
      delete "/api/links/#{@link.id}"
      expect(last_response.status).to eq(403)
    end
  end
end

describe 'Dashboard' do
  before do
    @user = create_user(role: 'editor')
    login
    Link.create(name: 'link1', url: 'https://example1.com', hits: 10)
    Link.create(name: 'link2', url: 'https://example2.com', hits: 5)
  end

  describe 'GET /dashboard' do
    it 'displays dashboard for authenticated users' do
      get '/dashboard'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Dashboard')
    end

    it 'shows link statistics' do
      get '/dashboard'
      expect(last_response.body).to include('2')
      expect(last_response.body).to include('15')
    end

    it 'rejects unauthenticated access' do
      get '/logout'
      get '/dashboard'
      expect(last_response).to be_redirect
    end
  end
end

describe 'Settings' do
  before do
    @user = create_user(email: 'user@hamzi.dev')
    login
  end

  describe 'GET /settings' do
    it 'displays settings page' do
      get '/settings'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Account Settings')
    end
  end

  describe 'POST /settings/password' do
    it 'updates password with correct current password' do
      post '/settings/password',
           current_password: 'password123',
           new_password: 'newpassword123',
           confirm_password: 'newpassword123'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Password updated successfully')
    end

    it 'rejects incorrect current password' do
      post '/settings/password',
           current_password: 'wrongpassword',
           new_password: 'newpassword123',
           confirm_password: 'newpassword123'
      expect(last_response.body).to include('Current password is incorrect')
    end

    it 'rejects mismatched passwords' do
      post '/settings/password',
           current_password: 'password123',
           new_password: 'newpassword123',
           confirm_password: 'different'
      expect(last_response.body).to include('Password confirmation does not match')
    end
  end

  describe 'POST /settings/notifications' do
    it 'updates notification preferences' do
      post '/settings/notifications', email_notifications_enabled: 'true'
      @user.refresh
      expect(@user.email_notifications_enabled).to be true
    end
  end
end

describe 'Error Handling' do
  it 'returns 404 for non-existent pages' do
    get '/nonexistent-page'
    expect(last_response.status).to eq(404)
    expect(last_response.body).to include('404')
  end
end
