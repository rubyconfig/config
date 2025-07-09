# Rails 5.x, 6.0 requires Ruby < 3
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

# Test rails 6.1 with psych >= 4
appraise 'rails-6.1' do
  gem 'activerecord-jdbcsqlite3-adapter', '~> 61.1', platform: :jruby
  gem 'bootsnap', '>= 1.4.4'
  gem 'drb', '~> 2.2' if RUBY_VERSION >= '3.4'
  gem 'mutex_m', '~> 0.2.0' if RUBY_VERSION >= '3.4'
  gem 'rails', '6.1.7.10'
  gem 'rspec-rails', '~> 5.0'
  gem 'sqlite3', '~> 1.4', platform: :ruby
  gem 'psych', '>= 4'
end

# Temporarily exclude Truffleruby and JRuby from testing in Rails 7.x until they fix the issues upstream.
# See https://github.com/rubyconfig/config/pull/344#issuecomment-1766209753
# if (RUBY_ENGINE == 'ruby' && RUBY_VERSION >= '2.7') || RUBY_ENGINE != 'ruby'
if RUBY_ENGINE == 'ruby' && RUBY_VERSION >= '2.7'
  appraise 'rails-7.0' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 70.1', platform: :jruby
    gem 'sqlite3', '~> 1.6.4', platform: :ruby
    gem 'bootsnap', '>= 1.4.4'
    gem 'drb', '~> 2.2' if RUBY_VERSION >= '3.4'
    gem 'mutex_m', '~> 0.2.0' if RUBY_VERSION >= '3.4'
    gem 'rails', '7.0.8.7'
    gem 'rspec-rails', '~> 6.0.3'
    gem 'sprockets-rails', '~> 3.4.2'
    gem 'psych', '>= 4'
  end

  appraise 'rails-7.1' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 70.1', platform: :jruby
    gem 'sqlite3', '~> 1.6.6', platform: :ruby
    gem 'bootsnap', '>= 1.16.0'
    gem 'rails', '7.1.5.1'
    gem 'rspec-rails', '~> 6.0.3'
    gem 'sprockets-rails', '~> 3.4.2'
    gem 'psych', '>= 4'
  end
end

appraise 'sinatra' do
  gem 'sinatra', '2.0.8.1'
end
