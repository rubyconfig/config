# Rails 5.x, 6.0 requires Ruby < 3
if RUBY_ENGINE == 'ruby' && RUBY_VERSION <= '3.0'
  appraise 'rails-5.2' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 71.0', platform: :jruby
    gem 'bootsnap', '~> 1.18.6'
    gem 'rails', '5.2.8.1'
    gem 'rspec-rails', '~> 3.7'
    gem 'sqlite3', '< 1.4.0', platform: :ruby
  end

  appraise 'rails-6.0' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 71.0', platform: :jruby
    gem 'bootsnap', '~> 1.18.6'
    gem 'rails', '6.0.6.1'
    gem 'rspec-rails', '~> 3.7'
    gem 'sqlite3', '~> 1.4.0', platform: :ruby
  end
end

# Test rails 6.1 with psych >= 4
appraise 'rails-6.1' do
  gem 'activerecord-jdbcsqlite3-adapter', '~> 71.0', platform: :jruby
  gem 'bootsnap', '>= 1.18.6'
  gem 'drb', '~> 2.2' if RUBY_VERSION >= '3.4'
  gem 'mutex_m', '~> 0.2.0' if RUBY_VERSION >= '3.4'
  gem 'rails', '6.1.7.10'
  gem 'rspec-rails', '~> 5.0'
  gem 'sqlite3', '~> 1.4.0', platform: :ruby if RUBY_VERSION < '3'
  gem 'sqlite3', '~> 2.7.2', platform: :ruby if RUBY_VERSION >= '3'
  gem 'psych', '>= 4'
end

# Temporarily exclude Truffleruby and JRuby from testing in Rails 7.x until they fix the issues upstream.
# See https://github.com/rubyconfig/config/pull/344#issuecomment-1766209753
# if (RUBY_ENGINE == 'ruby' && RUBY_VERSION >= '2.7') || RUBY_ENGINE != 'ruby'
if RUBY_ENGINE == 'ruby' && RUBY_VERSION >= '2.7'
  appraise 'rails-7.0' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 71.0', platform: :jruby
    gem 'bootsnap', '>= 1.18.6'
    gem 'drb', '~> 2.2' if RUBY_VERSION >= '3.4'
    gem 'mutex_m', '~> 0.2.0' if RUBY_VERSION >= '3.4'
    gem 'rails', '7.0.8.7'
    gem 'rspec-rails', '~> 7.1.1'
    gem 'sprockets-rails', '~> 3.5.2'
    gem 'psych', '>= 4'
    gem 'sqlite3', '~> 1.4.0', platform: :ruby if RUBY_VERSION < '3'
    gem 'sqlite3', '~> 2.7.2', platform: :ruby if RUBY_VERSION >= '3'
  end

  appraise 'rails-7.1' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 71.0', platform: :jruby
    gem 'sqlite3', '~> 2.7.2', platform: :ruby
    gem 'bootsnap', '>= 1.18.6'
    gem 'rails', '7.1.5.1'
    gem 'rspec-rails', '~> 7.1.1'
    gem 'sprockets-rails', '~> 3.5.2'
    gem 'psych', '>= 4'
    gem 'sqlite3', '~> 1.4.0', platform: :ruby if RUBY_VERSION < '3'
    gem 'sqlite3', '~> 2.7.2', platform: :ruby if RUBY_VERSION >= '3'
  end

  appraise 'rails-7.2' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 71.0', platform: :jruby
    gem 'sqlite3', '~> 2.7.2', platform: :ruby
    gem 'bootsnap', '>= 1.18.6'
    gem 'rails', '7.2.2.1'
    gem 'rspec-rails', '~> 7.1.1'
    gem 'sprockets-rails', '~> 3.5.2'
    gem 'psych', '>= 4'
    gem 'sqlite3', '~> 1.4.0', platform: :ruby if RUBY_VERSION < '3'
    gem 'sqlite3', '~> 2.7.2', platform: :ruby if RUBY_VERSION >= '3'
  end
end

if (RUBY_ENGINE == 'ruby' && Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.2.0')) || RUBY_ENGINE != 'ruby'
  appraise 'rails-8.0' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 71.0', platform: :jruby
    gem 'sqlite3', '~> 1.6.6', platform: :ruby
    gem 'bootsnap', '>= 1.18.6'
    gem 'kamal', '~> 2.7.0'
    gem 'rails', '8.0.2'
    gem 'rspec-rails', '~> 8.0.1'
    gem 'sprockets-rails', '~> 3.5.2'
    gem 'psych', '>= 4'
    gem 'sqlite3', '~> 1.4.0', platform: :ruby if RUBY_VERSION < '3'
    gem 'sqlite3', '~> 2.7.2', platform: :ruby if RUBY_VERSION >= '3'
  end
end

appraise 'sinatra' do
  gem 'sinatra', '2.0.8.1'
end
