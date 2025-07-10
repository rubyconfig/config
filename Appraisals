max_ruby_version = ->(version) {
  (RUBY_ENGINE == 'ruby' && Gem::Version.new(RUBY_VERSION) <= Gem::Version.new(version)) || RUBY_ENGINE != 'ruby'
}

min_ruby_version = ->(version) {
  (RUBY_ENGINE == 'ruby' && Gem::Version.new(RUBY_VERSION) >= Gem::Version.new(version)) || RUBY_ENGINE != 'ruby'
}

# Rails 5.x, 6.0 require Ruby < 3
if max_ruby_version.call('3.0')
  appraise 'rails-5.2' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 52.5', platform: :jruby
    gem 'bootsnap', '~> 1.4'
    gem 'rails', '~> 5.2.0'
    gem 'rspec-rails', '~> 3.7'
    gem 'sqlite3', '< 1.4.0', platform: :ruby
  end

  appraise 'rails-6.0' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 60.1', platform: :jruby
    gem 'bootsnap', '~> 1.4'
    gem 'rails', '~> 6.0.0'
    gem 'rspec-rails', '~> 3.7'
    gem 'sqlite3', '~> 1', platform: :ruby
  end
end

appraise 'rails-6.1' do
  gem 'activerecord-jdbcsqlite3-adapter', '~> 61.1', platform: :jruby
  gem 'bootsnap', '>= 1.4.4'
  gem 'drb', '~> 2.2' if min_ruby_version.call('3.4')
  gem 'mutex_m', '~> 0.2.0' if min_ruby_version.call('3.4')
  gem 'psych', '>= 4'
  gem 'rails', '~> 6.1.0'
  gem 'rspec-rails', '~> 5.0'
  gem 'sqlite3', '~> 1', platform: :ruby
end

# Rails 7.x require Ruby > 2.7
if min_ruby_version.call('2.7')
  appraise 'rails-7.0' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 70.1', platform: :jruby
    gem 'bootsnap', '>= 1.4.4'
    gem 'drb', '~> 2.2' if min_ruby_version.call('3.4')
    gem 'mutex_m', '~> 0.2.0' if min_ruby_version.call('3.4')
    gem 'psych', '>= 4'
    gem 'rails', '~> 7.0.0'
    gem 'rspec-rails', '~> 7.0'
    gem 'sprockets-rails', '~> 3.5.2'
    gem 'sqlite3', '~> 1', platform: :ruby
  end

  appraise 'rails-7.1' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 70.1', platform: :jruby
    gem 'bootsnap', '>= 1.16.0'
    gem 'psych', '>= 4'
    gem 'rails', '~> 7.1.0'
    gem 'rspec-rails', '~> 7.0'
    gem 'sprockets-rails', '~> 3.5.2'
    gem 'sqlite3', '~> 1', platform: :ruby
  end

end

# Rails 7.2 requires Ruby > 3.1
if min_ruby_version.call('3.1.0')
  appraise 'rails-7.2' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 70.1', platform: :jruby
    gem 'bootsnap', '>= 1.16.0'
    gem 'psych', '>= 4'
    gem 'rails', '~> 7.2.0'
    gem 'rspec-rails', '~> 7.0'
    gem 'sprockets-rails', '~> 3.5.2'
    gem 'sqlite3', '~> 1', platform: :ruby
  end
end

# Rails 8.0 requires Ruby > 3.2
if min_ruby_version.call('3.2.0') && RUBY_ENGINE != 'jruby'
  appraise 'rails-8.0' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 70.1', platform: :jruby
    gem 'bootsnap', '>= 1.16.0'
    gem 'kamal', '~> 2.7.0'
    gem 'rails', '~> 8.0.0'
    gem 'rspec-rails', '~> 8.0'
    gem 'psych', '>= 4'
    gem 'sqlite3', '>= 2.1', platform: :ruby
  end
end

appraise 'sinatra' do
  gem 'sinatra', '2.0.8.1'
end
