require 'test/unit'
require 'app_config'

class AppConfigTest < Test::Unit::TestCase
  
  def test_missing_files
    config = ApplicationConfig.load_files('not_here1', 'not_here2')
    assert_equal OpenStruct.new, config
  end
  
  def test_empty_files
    config = ApplicationConfig.load_files('test/empty1.yml', 'test/empty2.yml')
    assert_equal OpenStruct.new, config
  end
  
  def test_common
    config = ApplicationConfig.load_files('test/app_config.yml')
    assert_equal 1, config.size
    assert_equal 'google.com', config.server
  end
  
  def test_environment_override
    config = ApplicationConfig.load_files('test/app_config.yml', 'test/development.yml')
    assert_equal 2, config.size
    assert_equal 'google.com', config.server
  end
  
  def test_nested
    config = ApplicationConfig.load_files('test/development.yml')
    assert_equal 3, config.section.size
  end
  
  def test_array
    config = ApplicationConfig.load_files('test/development.yml')
    assert_equal 'yahoo.com', config.section.servers[0].name
    assert_equal 'amazon.com', config.section.servers[1].name
  end
  
  def test_erb
    config = ApplicationConfig.load_files('test/development.yml')
    assert_equal 6, config.computed
  end
  
end
