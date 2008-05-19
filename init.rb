require 'app_config'

::AppConfig = ApplicationConfig.load_files(RAILS_ROOT+"/config/app_config.yml",
                                           RAILS_ROOT+"/config/environments/#{RAILS_ENV}.yml")