module ApplicationConfig
  module ViewHelpers
    def javascripts_from_config(options = {})
      html = ""
      only = [options.delete(:only)].flatten.compact.map{|i| i.to_s}
      if defined?(AppConfig) and AppConfig.javascripts
        
        ConfigBuilder.merge_assets(AppConfig.javascripts).each do |javascript|
          if javascript.is_a? Hash
            javascript.each do |key, val|
              next unless only.empty? || only.include?(key.to_s)

              args = [val].flatten
              args = args.map{|s| s.gsub("javascripts/", AppConfig.javascript_path)} if AppConfig.javascript_path
              if defined?(Merb)
                args << options.merge(:bundle => key.to_sym)
                html << js_include_tag(*args).to_s
              elsif defined?(Rails)
                args << options.merge(:cache => key.to_s)
                html << javascript_include_tag(*args).to_s
              end
              html << "\n"
            end
          else
            args = [javascript].flatten
            args = args.map{|s| s.gsub("javascripts/", AppConfig.javascript_path)} if AppConfig.javascript_path
            args << options
            if defined?(Merb)
              html << js_include_tag(*args).to_s
            elsif defined?(Rails)
              html << javascript_include_tag(*args).to_s
            end
          end
        end
      end
      return html
    end
    
    def stylesheets_from_config(options = {})
      html = ""
      only = [options.delete(:only)].flatten.compact.map{|i| i.to_s}
      if defined?(AppConfig) and AppConfig.stylesheets
        ConfigBuilder.merge_assets(AppConfig.stylesheets).each do |stylesheet|
          if stylesheet.is_a? Hash
            stylesheet.each do |key, val|
              next unless only.empty? || only.include?(key.to_s)
              
              args = [val].flatten
              args = args.map{|s| s.gsub("stylesheets/", AppConfig.stylesheet_path)} if AppConfig.stylesheet_path
              if defined?(Merb)
                args << options.merge(:bundle => key.to_sym)
                html << css_include_tag(*args).to_s
              elsif defined?(Rails)
                args << options.merge(:cache => key.to_s)
                html << stylesheet_link_tag(*args).to_s
              end
            end
          else
            args = [stylesheet].flatten
            args = args.map{|s| s.gsub("stylesheets/", AppConfig.stylesheet_path)} if AppConfig.stylesheet_path
            args << options
            if defined?(Merb)
              html << css_include_tag(*args).to_s
            elsif defined?(Rails)
              html << stylesheet_link_tag(*args).to_s
            end
          end
          html << "\n"
        end
      end
      return html
    end
  end
end