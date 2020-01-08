# Bundler >= 2.x do not work with Rails 4.2
if (ENV['BUNDLER_VERSION'] || `bundler -v`[/\d+\.\d+\.\d+/]).start_with?('1.17')
  appraise 'rails-4.2' do
    gem 'rails', '4.2.11.1'
    gem 'rspec-rails', '~> 3.7'
    gem 'sprockets', '~> 3.7'
    gem 'sqlite3', '< 1.4.0'
    gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
  end
else
  puts 'Skipping rails-4.2 for Bundler >= 2.x'
end

appraise 'rails-5.0' do
  gem 'rails', '5.0.7.2'
  gem 'rspec-rails', '~> 3.7'
  gem 'sqlite3', '< 1.4.0'
end

appraise 'rails-5.1' do
  gem 'rails', '5.1.7'
  gem 'rspec-rails', '~> 3.7'
  gem 'sqlite3', '< 1.4.0'
end

appraise 'rails-5.2' do
  gem 'bootsnap', '~> 1.4'
  gem 'rails', '5.2.4.1'
  gem 'rspec-rails', '~> 3.7'
  gem 'sqlite3', '< 1.4.0'
end

if RUBY_VERSION >= '2.5.0' do
  appraise 'rails-6.0' do
    gem 'bootsnap', '~> 1.4'
    gem 'rails', '6.0.2.1'
    gem 'rspec-rails', '~> 3.7'
    gem 'sqlite3', '~> 1.4.0'
  end
end

appraise 'sinatra' do
  gem 'sinatra', '2.0.8.1'
end
