# Rails 5.x, 6.0 requires Ruby < 3
if RUBY_ENGINE == 'ruby' && RUBY_VERSION <= '3.0'
  appraise 'rails-5.2' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 52.5', platform: :jruby
    gem 'bootsnap', '~> 1.4'
    gem 'rails', '5.2.4.3'
    gem 'rspec-rails', '~> 3.7'
    gem 'sqlite3', '< 1.4.0', platform: :ruby
  end

  appraise 'rails-6.0' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 60.1', platform: :jruby
    gem 'bootsnap', '~> 1.4'
    gem 'rails', '6.0.3.1'
    gem 'rspec-rails', '~> 3.7'
    gem 'sqlite3', '~> 1.4.0', platform: :ruby
  end
end

# Test rails 6.1 with psych >= 4
appraise 'rails-6.1' do
  gem 'activerecord-jdbcsqlite3-adapter', '~> 61.1', platform: :jruby
  gem 'bootsnap', '>= 1.4.4'
  gem 'rails', '6.1.4'
  gem 'rspec-rails', '~> 5.0'
  gem 'sqlite3', '~> 1.4', platform: :ruby
  gem 'psych', '>= 4'
end

appraise 'sinatra' do
  gem 'sinatra', '2.0.8.1'
end
