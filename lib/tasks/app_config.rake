namespace :app_config do
  desc "Create a blank config/app_config.yml file"
  task :init do
    puts "Setting up AppConfig files..."
    `mkdir -p config/app_config`
    
    ["config/app_config.yml",
     "config/app_config/development.yml",
     "config/app_config/production.yml"
    ].each do |path|
      `touch #{path}`
      puts "Created: #{path}"
    end
    puts "Complete!"
    puts "Add key/value pairs to your yaml file,\nthen access them in your Merb project via AppConfig.[key]"
  end
end