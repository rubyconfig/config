require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "rails_app_config"
    s.summary = "provides an AppConfig for rails3 that reads config/app_config.yml"
    s.email = "railsjedi@gmail.com"
    s.homepage = "http://github.com/railsjedi/rails_app_config"
    s.description = "Provides an easy to use Application Configuration object"
    s.authors = ["Jacques Crocker"]
    s.files =  FileList["[A-Z]*", "{bin,generators,lib,test}/**/*"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  # puts "Jeweler, or one of its dependencies, is not available. Install it with: gem install jeweler"
end