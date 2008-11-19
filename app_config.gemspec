Gem::Specification.new do |s|
  s.name = 'app_config'
  s.version = '1.5'
  s.date = '2008-11-18'
  
  s.summary = "Application level configuration"
  s.description = "Allow application wide configuration settings via YML files"
  
  s.authors = ['RailsJedi', 'Christopher J. Bottaro']
  s.email = 'railsjedi@gmail.com'
  s.homepage = 'http://github.com/jcnetdev/app_config'
  
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README"]
  
  s.files = ["README",
             "README.rdoc",
             "app_config.gemspec",
             "init.rb",
             "lib/app_config.rb",
             "lib/application_config/config_builder.rb",
             "lib/application_config/view_helpers.rb",
             "rails/init.rb"]
  
  s.test_files = ["test/app_config.yml",
                  "test/app_config_test.rb",
                  "test/development.yml",
                  "test/empty1.yml",
                  "test/empty2.yml"]

end