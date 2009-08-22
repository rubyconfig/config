require 'rubygems'
require 'test/unit'
require 'active_support'
require File.dirname(__FILE__)+'/../lib/application_config/config_builder'
require File.dirname(__FILE__)+'/../lib/application_config/deep_merge'

class ConfigBuilderTest < Test::Unit::TestCase
  def setup
    @settings_path = File.dirname(__FILE__)+"/test_configs"
  end
  
  def test_missing_files
    files = ["#{@settings_path}/empty1.yml", "#{@settings_path}/empty2.yml"]
    config = ApplicationConfig::ConfigBuilder.load_files(:paths => files)
    assert_equal OpenStruct.new, config
  end
  
  def test_empty_files
    files = ["#{@settings_path}/empty1.yml", "#{@settings_path}/empty2.yml"]
    config = ApplicationConfig::ConfigBuilder.load_files(:paths => files)
    assert_equal OpenStruct.new, config
  end
  
  def test_common
    config = ApplicationConfig::ConfigBuilder.load_files(:paths => "#{@settings_path}/app_config.yml")
    assert_equal 1, config.size
    assert_equal 'google.com', config.server
  end
  
  def test_environment_override
    config = ApplicationConfig::ConfigBuilder.load_files(:paths => ["#{@settings_path}/app_config.yml", "#{@settings_path}/development.yml"])
    assert_equal 2, config.size
    assert_equal 'google.com', config.server
  end
  
  def test_nested
    config = ApplicationConfig::ConfigBuilder.load_files(:paths => ["#{@settings_path}/development.yml"])
    assert_equal 3, config.section.size
  end
  
  def test_array
    config = ApplicationConfig::ConfigBuilder.load_files(:paths => "#{@settings_path}/development.yml")
    assert_equal 'yahoo.com', config.section.servers[0].name
    assert_equal 'amazon.com', config.section.servers[1].name
  end
  
  def test_erb
    config = ApplicationConfig::ConfigBuilder.load_files(:paths => "#{@settings_path}/development.yml")
    assert_equal 6, config.computed
  end
  
  def test_javascript_expander
    config = ApplicationConfig::ConfigBuilder.load_files(
              :paths => "#{@settings_path}/javascript_expander.yml",
              :root_path => "#{@settings_path}/javascript_expander",
              :expand_keys => :javascripts
            )

    # puts "JAVASCRIPTS:"
    # puts config.inspect
    assert_equal 4, config.javascripts.first.base.size
  end

  def test_stylesheet_expander
    config = ApplicationConfig::ConfigBuilder.load_files(
              :paths => "#{@settings_path}/stylesheet_expander.yml", 
              :root_path => "#{@settings_path}/stylesheet_expander",
              :expand_keys => :stylesheets
            )

    # puts "STYLESHEETS:"
    # puts config.inspect
    assert_equal 5, config.stylesheets.first.base.size
  end
  
  def test_merge_hashes_from_multiple_configs
    config = ApplicationConfig::ConfigBuilder.load_files(:paths => ["#{@settings_path}/deep_merge/config1.yml", "#{@settings_path}/deep_merge/config2.yml"])

    assert_equal 3, config.inner.marshal_dump.keys.size
    assert_equal 3, config.inner2.inner2_inner.marshal_dump.keys.size
  end


  def test_merge_arrays_from_multiple_configs
    config = ApplicationConfig::ConfigBuilder.load_files(:paths => ["#{@settings_path}/deep_merge/config1.yml", "#{@settings_path}/deep_merge/config2.yml"])
    assert_equal 6, config.arraylist1.size
    assert_equal 6, config.arraylist2.inner.size
  end
  
  def test_merge_assets
    config = ApplicationConfig::ConfigBuilder.load_files(:paths => ["#{@settings_path}/deep_merge/config1.yml", "#{@settings_path}/deep_merge/config2.yml"])
    merged = ApplicationConfig::ConfigBuilder.merge_assets(config.hash_array)
    
    assert_equal 3, merged.size
    assert_equal 6, merged.select{|i| i.is_a?(Hash)}.first[:inner].size
  end
  
  def test_merge_assets2
    config = ApplicationConfig::ConfigBuilder.load_files(:paths => ["#{@settings_path}/deep_merge2/config1.yml", "#{@settings_path}/deep_merge2/config2.yml"])
    
    assert_equal 500, config.tvrage.cache
    assert_equal "http://url2", config.tvrage.service_url
  end
  
end
