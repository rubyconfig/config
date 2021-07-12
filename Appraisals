# Bundler >= 2.x do not work with Rails 4.2
puts `bundle -v`

if (`bundle -v`[/\d+\.\d+\.\d+/]).start_with?('1.17')
  appraise 'rails-4.2' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 1.3.25', platform: :jruby
    gem 'rails', '4.2.11.3'
    gem 'rspec-rails', '~> 3.7'
    gem 'sprockets', '~> 3.7'
    gem 'sqlite3', '< 1.4.0', platform: :ruby
    gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
  end
else
  puts 'Skipping rails-4.2 for Bundler >= 2.x'
end

appraise 'rails-5.0' do
  gem 'activerecord-jdbcsqlite3-adapter', '~> 50.6', platform: :jruby
  gem 'rails', '5.0.7.2'
  gem 'rspec-rails', '~> 3.7'
  gem 'sqlite3', '< 1.4.0', platform: :ruby
end

appraise 'rails-5.1' do
  gem 'activerecord-jdbcsqlite3-adapter', '~> 51.6', platform: :jruby
  gem 'rails', '5.1.7'
  gem 'rspec-rails', '~> 3.7'
  gem 'sqlite3', '< 1.4.0', platform: :ruby
end

appraise 'rails-5.2' do
  gem 'activerecord-jdbcsqlite3-adapter', '~> 52.5', platform: :jruby
  gem 'bootsnap', '~> 1.4'
  gem 'rails', '5.2.5'
  gem 'rspec-rails', '~> 3.7'
  gem 'sqlite3', '< 1.4.0', platform: :ruby
end

# Rails 6.x requires Ruby >= 2.5.0
if (RUBY_ENGINE == 'ruby' && RUBY_VERSION >= '2.5.0') || RUBY_ENGINE != 'ruby'
  appraise 'rails-6.0' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 60.1', platform: :jruby
    gem 'bootsnap', '~> 1.4'
    gem 'rails', '6.0.3.6'
    gem 'rspec-rails', '~> 3.7'
    gem 'sqlite3', '~> 1.4.0', platform: :ruby
  end
else
  puts 'Skipping rails-6.0 for Ruby < 2.5'
end

# Rails 6.x requires Ruby >= 2.5.0
if (RUBY_ENGINE == 'ruby' && RUBY_VERSION >= '2.5.0') || RUBY_ENGINE != 'ruby'
  appraise 'rails-6.1' do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 60.1', platform: :jruby
    gem 'bootsnap', '~> 1.4'
    gem 'rails', '6.1.3.1'
    gem 'rspec-rails', '~> 3.7'
    gem 'sqlite3', '~> 1.4.0', platform: :ruby
  end
else
  puts 'Skipping rails-6.0 for Ruby < 2.5'
end


appraise 'sinatra' do
  gem 'sinatra', '2.0.8.1'
end
