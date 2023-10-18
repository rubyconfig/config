# Rails 5.x, 6.0 require Ruby < 3
if RUBY_ENGINE == 'ruby' && RUBY_VERSION <= '3.0'
  appraise 'rails-5.2' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 52.5', platform: :jruby
    gem 'bootsnap', '~> 1.4'
    gem 'rails', '5.2.8.1'
    gem 'rspec-rails', '~> 3.7'
    gem 'sqlite3', '< 1.4.0', platform: :ruby
  end

  appraise 'rails-6.0' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 60.1', platform: :jruby
    gem 'bootsnap', '~> 1.4'
    gem 'rails', '6.0.6.1'
    gem 'rspec-rails', '~> 3.7'
    gem 'sqlite3', '~> 1.4.0', platform: :ruby
  end
end

# Rails 6.1 with psych >= 4
appraise 'rails-6.1' do
  gem 'activerecord-jdbcsqlite3-adapter', '~> 61.1', platform: :jruby
  gem 'bootsnap', '>= 1.4.4'
  gem 'rails', '6.1.7.6'
  gem 'rspec-rails', '~> 5.0'
  gem 'sqlite3', '~> 1.4', platform: :ruby
  gem 'psych', '>= 4'
end

# Rails 7.x require Ruby >= 2.7
if (RUBY_ENGINE == 'ruby' && RUBY_VERSION >= '2.7') || RUBY_ENGINE != 'ruby'
  appraise 'rails-7.0' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 70.1', platform: :jruby
    gem 'sqlite3', '~> 1.6.4', platform: :ruby
    gem 'bootsnap', '>= 1.4.4'
    gem 'rails', '7.0.8'
    gem 'rspec-rails', '~> 6.0.3'
    gem 'sprockets-rails', '~> 3.4.2'
    gem 'psych', '>= 4'
  end

  appraise 'rails-7.1' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 70.1', platform: :jruby
    gem 'sqlite3', '~> 1.6.6', platform: :ruby
    gem 'bootsnap', '>= 1.16.0'
    gem 'rails', '7.1.0'
    gem 'rspec-rails', '~> 6.0.3'
    gem 'sprockets-rails', '~> 3.4.2'
    gem 'psych', '>= 4'
  end
end

appraise 'sinatra' do
  gem 'sinatra', '2.0.8.1'
end
