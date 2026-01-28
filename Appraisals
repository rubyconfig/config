max_ruby_version = ->(version) {
  RUBY_ENGINE == 'ruby' && Gem::Version.new(RUBY_VERSION) <= Gem::Version.new(version)
}

min_ruby_version = ->(version) {
  RUBY_ENGINE == 'ruby' && Gem::Version.new(RUBY_VERSION) >= Gem::Version.new(version)
}

# Rails 8.0 requires Ruby > 3.2
if min_ruby_version.call('3.2.0')
  appraise 'rails-8.0' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 71.0', platform: :jruby
    gem 'bootsnap', '>= 1.16.0'
    gem 'kamal', '~> 2.7.0'
    gem 'rails', '~> 8.0.0'
    gem 'rspec-rails', '~> 8.0'
    gem 'psych', '>= 4'
    gem 'sqlite3', '>= 2.1', platform: :ruby
  end

  # Rails 7.2 requires Ruby > 3.1 but 3.1 is EOL.
  appraise 'rails-7.2' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 71.0', platform: :jruby
    gem 'bootsnap', '>= 1.16.0'
    gem 'psych', '>= 4'
    gem 'rails', '~> 7.2.0'
    gem 'rspec-rails', '~> 7.0'
    gem 'sprockets-rails', '~> 3.5.2'
    gem 'sqlite3', '~> 1', platform: :ruby
  end
end

# Rails 8.1 requires Ruby > 3.3
if min_ruby_version.call('3.3.0')
  appraise 'rails-8.1' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 71.0', platform: :jruby
    gem 'bootsnap', '>= 1.16.0'
    gem 'kamal', '~> 2.7.0'
    gem 'rails', '~> 8.1.0'
    gem 'rspec-rails', '~> 8.0'
    gem 'psych', '>= 4'
    gem 'sqlite3', '>= 2.1', platform: :ruby
  end
end

appraise 'sinatra' do
  gem 'sinatra', '~> 4.2.0'
end
