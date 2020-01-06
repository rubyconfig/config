# TruffleRuby does not seem to work with Rails
unless RUBY_ENGINE == 'truffleruby'

  # Bundler 2.x coming with Ruby 2.7 does not work well with rails 4.2
  if RUBY_VERSION < '2.7.0'
    appraise 'rails-4.2' do
      gem 'rails', '4.2.11.1'
      gem 'rspec-rails', '~> 3.7'
      gem 'sprockets', '~> 3.7'
      gem 'sqlite3', '< 1.4.0'
      gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
    end
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

end

appraise 'rails-5.2' do
  gem 'bootsnap', '~> 1.4'
  gem 'rails', '5.2.4.1'
  gem 'rspec-rails', '~> 3.7'
  gem 'sqlite3', '< 1.4.0'
end

appraise 'sinatra' do
  gem 'sinatra', '2.0.8.1'
end
