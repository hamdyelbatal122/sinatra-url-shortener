require_relative '../app'

# Seed initial data only in development / fresh installs
if User.count.zero?
  admin = User.new(username: 'admin', role: 'admin', email: 'admin@example.com')
  admin.password = 'admin123'
  admin.save
  puts '✓ Admin user created  →  username: admin / password: admin123'
  puts '  ⚠  Change the default password immediately after first login.'
end

if Link.count.zero?
  [
    { name: 'github',   url: 'https://github.com',       category: 'dev',  tags: 'code,git'        },
    { name: 'docs',     url: 'https://sinatrarb.com',    category: 'docs', tags: 'sinatra,ruby'    },
    { name: 'rubygems', url: 'https://rubygems.org',     category: 'dev',  tags: 'gems,ruby'       }
  ].each do |attrs|
    Link.create(attrs)
    puts "✓ Sample link created  →  /#{attrs[:name]}"
  end
end
