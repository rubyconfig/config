# Config

[![Version](https://img.shields.io/gem/v/config)](https://rubygems.org/gems/config)
[![Downloads Total](https://img.shields.io/gem/dt/config)](https://rubygems.org/gems/config)
[![Tests](https://github.com/rubyconfig/config/workflows/tests/badge.svg)](https://github.com/rubyconfig/config/actions?query=branch%3Amaster)
[![Financial Contributors on Open Collective](https://opencollective.com/rubyconfig/all/badge.svg?label=backers)](https://opencollective.com/rubyconfig)

## Summary

Config helps you easily manage environment specific settings in an easy and usable manner.

## Features

* simple YAML config files
* config files support ERB
* config files support inheritance and multiple environments
* access config information via convenient object member notation
* support for multi-level settings (`Settings.group.subgroup.setting`)
* local developer settings ignored when committing the code

## Compatibility

Current version supports and is [tested](.github/workflows/tests.yml#L19) for the following interpreters and frameworks:

* Interpreters
  * [Ruby](https://www.ruby-lang.org) `>= 2.6`
  * [JRuby](https://www.jruby.org) `>= 9.2`
  * [TruffleRuby](https://github.com/oracle/truffleruby) `>= 19.3`
* Application frameworks
  * Rails `>= 5.2`
  * Padrino
  * Sinatra

For Ruby `2.0` to `2.3` or Rails `3` to `4.1` use version `1.x` of this gem. For older versions of Rails or Ruby use [AppConfig](http://github.com/fredwu/app_config).

For Ruby `2.4` or `2.5` or Rails `4.2`, `5.0`, or `5.1` use version `3.x` of this gem.

## Installing

### Installing on Rails

Add `gem 'config'` to your `Gemfile` and run `bundle install` to install it. Then run

    rails g config:install

which will generate customizable config file `config/initializers/config.rb` and set of default settings files:

    config/settings.yml
    config/settings.local.yml
    config/settings/development.yml
    config/settings/production.yml
    config/settings/test.yml

You can now edit them to adjust to your needs.

> Note: By default, the config environment will match the Rails environment (`Rails.env`). This can be changed by setting `config.environment`.

You can also define your own settings files and load them in the initializer:

```ruby
Config.setup do |config|
  config.load_and_set_settings("/path/to/yaml1", "/path/to/yaml2", ...)
end
```

### Installing on Padrino

Add the gem to your `Gemfile` and run `bundle install` to install it. Then edit `app.rb` and register `Config`

```ruby
register Config
```

### Installing on Sinatra

Add the gem to your `Gemfile` and run `bundle install` to install it. Afterwards in need to register `Config` in your app and give it a root so it can find the config files.

```ruby
set :root, File.dirname(__FILE__)
register Config
```

### Installing on other ruby projects

Add the gem to your `Gemfile` and run `bundle install` to install it. Then initialize `Config` manually within your configure block.

```ruby
Config.load_and_set_settings(Config.setting_files("/path/to/config_root", "your_project_environment"))
```

It's also possible to initialize `Config` manually within your configure block if you want to just give it some yml paths to load from.

```ruby
Config.load_and_set_settings("/path/to/yaml1", "/path/to/yaml2", ...)
```

## Accessing the Settings object

After installing the gem, `Settings` object will become available globally and by default will be compiled from the files listed below. Settings defined in files that are lower in the list override settings higher.

    config/settings.yml
    config/settings/#{environment}.yml
    config/environments/#{environment}.yml

    config/settings.local.yml
    config/settings/#{environment}.local.yml
    config/environments/#{environment}.local.yml

Entries can be accessed via object member notation:

```ruby
Settings.my_config_entry
```

Nested entries are supported:

```ruby
Settings.my_section.some_entry
```

Alternatively, you can also use the `[]` operator if you don't know which exact setting you need to access ahead of time.

```ruby
# All the following are equivalent to Settings.my_section.some_entry
Settings.my_section[:some_entry]
Settings.my_section['some_entry']
Settings[:my_section][:some_entry]
```

### Reloading settings

You can reload the Settings object at any time by running `Settings.reload!`.

### Reloading settings and config files

You can also reload the `Settings` object from different config files at runtime.

For example, in your tests if you want to test the production settings, you can:

```ruby
Rails.env = "production"
Settings.reload_from_files(
  Rails.root.join("config", "settings.yml").to_s,
  Rails.root.join("config", "settings", "#{Rails.env}.yml").to_s,
  Rails.root.join("config", "environments", "#{Rails.env}.yml").to_s
)
```

### Environment specific config files

You can have environment specific config files. Environment specific config entries take precedence over common config entries.

Example development environment config file:

```ruby
#{Rails.root}/config/environments/development.yml
```

Example production environment config file:

```ruby
#{Rails.root}/config/environments/production.yml
```

### Extra sources

You can load extra sources during initialization by setting the `extra_sources` configuration option.

```ruby
Config.setup do |config|
  config.extra_sources = [
    'path/to/extra_source.yml',          # String: loads extra_source.yml
    { api_key: ENV['API_KEY'] },         # Hash: direct hash source
    MyCustomSource.new,                  # Object: custom source object that responds to `load`
  ]
end
```

This will also overwrite the same config entries from the main file.

### Developer specific config files

If you want to have local settings, specific to your machine or development environment, you can use the following files, which are automatically `.gitignore` :

```ruby
Rails.root.join("config", "settings.local.yml").to_s,
Rails.root.join("config", "settings", "#{Rails.env}.local.yml").to_s,
Rails.root.join("config", "environments", "#{Rails.env}.local.yml").to_s
```

**NOTE:** The file `settings.local.yml` will not be loaded in tests to prevent local configuration from causing flaky or non-deterministic tests. Environment-specific files (e.g. `settings/test.local.yml`) will still be loaded to allow test-specific credentials.

### Adding sources at runtime

You can add new YAML config files at runtime. Just use:

```ruby
Settings.add_source!("/path/to/source.yml")
Settings.reload!
```

This will use the given source.yml file and use its settings to overwrite any previous ones.

On the other hand, you can prepend a YML file to the list of configuration files:

```ruby
Settings.prepend_source!("/path/to/source.yml")
Settings.reload!
```

This will do the same as `add_source`, but the given YML file will be loaded first (instead of last) and its settings will be overwritten by any other configuration file. This is especially useful if you want to define defaults.

One thing I like to do for my Rails projects is provide a local.yml config file that is .gitignored (so its independent per developer). Then I create a new initializer in `config/initializers/add_local_config.rb` with the contents

```ruby
Settings.add_source!("#{Rails.root}/config/settings/local.yml")
Settings.reload!
```

> Note: this is an example usage, it is easier to just use the default local
> files `settings.local.yml`, `settings/#{Rails.env}.local.yml` and
> `environments/#{Rails.env}.local.yml` for your developer specific settings.

You also have the option to add a raw hash as a source. One use case might be storing settings in the database or in environment variables that overwrite what is in the YML files.

```ruby
Settings.add_source!({some_secret: ENV['some_secret']})
Settings.reload!
```

You may pass a hash to `prepend_source!` as well.

## Embedded Ruby (ERB)

Embedded Ruby is allowed in the YAML configuration files. ERB will be evaluated at load time by default, and when the `evaluate_erb_in_yaml` configuration is set to `true`.

Consider the two following config files.

* ```#{Rails.root}/config/settings.yml```

```yaml
size: 1
server: google.com
```

* ```#{Rails.root}/config/environments/development.yml```

```yaml
size: 2
computed: <%= 1 + 2 + 3 %>
section:
  size: 3
  servers: [ {name: yahoo.com}, {name: amazon.com} ]
```

Notice that the environment specific config entries overwrite the common entries.

```ruby
Settings.size   # => 2
Settings.server # => google.com
```

Notice the embedded Ruby.

```ruby
Settings.computed # => 6
```

Notice that object member notation is maintained even in nested entries.

```ruby
Settings.section.size # => 3
```

Notice array notation and object member notation is maintained.

```ruby
Settings.section.servers[0].name # => yahoo.com
Settings.section.servers[1].name # => amazon.com
```

## Configuration

There are multiple configuration options available, however you can customize `Config` only once, preferably during application initialization phase:

```ruby
Config.setup do |config|
  config.const_name = 'Settings'
  # ...
end
```

After installing `Config` in Rails, you will find automatically generated file that contains default configuration located at `config/initializers/config.rb`.

### General

* `const_name` - name of the object holding your settings. Default: `'Settings'`
* `evaluate_erb_in_yaml` - evaluate ERB in YAML config files. Set to false if the config file contains ERB that should not be evaluated at load time. Default: `true`
* `file_name` - name of the file to store general keys accessible in all environments. Default: `'settings'` - located at `config/settings.yml`
* `dir_name` - name of the directory to store environment-specific files. Default: `'settings'` - located at `config/settings/`

### Merge customization

* `overwrite_arrays` - overwrite arrays found in previously loaded settings file. Default: `true`
* `merge_hash_arrays` - merge hashes inside of arrays from previously loaded settings files. Makes sense only when `overwrite_arrays = false`. Default: `false`
* `knockout_prefix` - ability to remove elements of the array set in earlier loaded settings file. Makes sense only when `overwrite_arrays = false`, otherwise array settings would be overwritten by default. Default: `nil`
* `merge_nil_values` - `nil` values will overwrite an existing value when merging configs. Default: `true`.

```ruby
# merge_nil_values is true by default
c = Config.load_files("./spec/fixtures/development.yml") # => #<Config::Options size=2, ...>
c.size # => 2
c.merge!(size: nil) => #<Config::Options size=nil, ...>
c.size # => nil
```

```ruby
# To reject nil values when merging settings:
Config.setup do |config|
  config.merge_nil_values = false
end

c = Config.load_files("./spec/fixtures/development.yml") # => #<Config::Options size=2, ...>
c.size # => 2
c.merge!(size: nil) => #<Config::Options size=nil, ...>
c.size # => 2
```

Check [Deep Merge](https://github.com/danielsdeleo/deep_merge) for more details.

### Validation

With Ruby 2.1 or newer, you can optionally define a [schema](https://github.com/dry-rb/dry-schema) or [contract](https://github.com/dry-rb/dry-validation) (added in `config-2.1`) using [dry-rb](https://github.com/dry-rb) to validate presence (and type) of specific config values. Generally speaking contracts allow to describe more complex validations with depencecies between fields.

If you provide either validation option (or both) it will automatically be used to validate your config. If validation fails it will raise a `Config::Validation::Error` containing information about all the mismatches between the schema and your config.

Both examples below demonstrates how to ensure that the configuration has an optional `email` and the `youtube` structure with the `api_key` field filled. The contract adds an additional rule.

#### Contract

Leverage dry-validation, you can create a contract with a params schema and rules:

```ruby
class ConfigContract < Dry::Validation::Contract
  params do
    optional(:email).maybe(:str?)

    required(:youtube).schema do
      required(:api_key).filled
    end
  end

  rule(:email) do
    unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
      key.failure('has invalid format')
    end
  end
end

Config.setup do |config|
  config.validation_contract = ConfigContract.new
end
```

The above example adds a rule to ensure the `email` is valid by matching it against the provided regular expression.

Check [dry-validation](https://github.com/dry-rb/dry-validation) for more details.

#### Schema

You may also specify a schema using [dry-schema](https://github.com/dry-rb/dry-schema):

```ruby
Config.setup do |config|
  # ...
  config.schema do
    optional(:email).maybe(:str?)

    required(:youtube).schema do
      required(:api_key).filled
    end
  end
end
```

Check [dry-schema](https://github.com/dry-rb/dry-schema) for more details.

### Missing keys

For an example settings file:

```yaml
size: 1
server: google.com
```

You can test if a value was set for a given key using `key?` and its alias `has_key?`:

```ruby
Settings.key?(:path)
# => false
Settings.key?(:server)
# => true
```

By default, accessing to a missing key returns `nil`:

```ruby
Settings.key?(:path)
# => false
Settings.path
# => nil
```

This is not "typo-safe". To solve this problem, you can configure the `fail_on_missing` option:

```ruby
Config.setup do |config|
  config.fail_on_missing = true
  # ...
end
```

So it will raise a `KeyError` when accessing a non-existing key (similar to `Hash#fetch` behaviour):

```ruby
Settings.path
# => raises KeyError: key not found: :path
```

### Environment variables

See section below for more details.

## Working with environment variables

To load environment variables from the `ENV` object, that will override any settings defined in files, set the `use_env` to true in your `config/initializers/config.rb` file:

```ruby
Config.setup do |config|
  config.const_name = 'Settings'
  config.use_env = true
end
```

Now config would read values from the ENV object to the settings. For the example above it would look for keys starting with `Settings`:

```ruby
ENV['Settings.section.size'] = 1
ENV['Settings.section.server'] = 'google.com'
```

It won't work with arrays, though.

It is considered an error to use environment variables to simultaneously assign a "flat" value and a multi-level value to a key.

```ruby
# Raises an error when settings are loaded
ENV['BACKEND_DATABASE'] = 'development'
ENV['BACKEND_DATABASE_USER'] = 'postgres'
```

Instead, specify keys of equal depth in the environment variable names:

```ruby
ENV['BACKEND_DATABASE_NAME'] = 'development'
ENV['BACKEND_DATABASE_USER'] = 'postgres'
```

### Working with Heroku

Heroku uses ENV object to store sensitive settings. You cannot upload such files to Heroku because it's ephemeral filesystem gets recreated from the git sources on each instance refresh. To use config with Heroku just set the `use_env` var to `true` as mentioned above.

To upload your local values to Heroku you could ran `bundle exec rake config:heroku`.

### Fine-tuning

You can customize how environment variables are processed:

* `env_prefix` (default: `const_name`) - load only ENV variables starting with this prefix (case-sensitive)
* `env_separator` (default: `'.'`)  - what string to use as level separator - default value of `.` works well with   Heroku, but you might want to change it for example for `__` to easy override settings from command line, where using   dots in variable names might not be allowed (eg. Bash)
* `env_converter` (default: `:downcase`)  - how to process variables names:
  * `nil` - no change
  * `:downcase` - convert to lower case
* `env_parse_values` (default: `true`) - try to parse values to a correct type (`Boolean`, `Integer`, `Float`, `String`)

For instance, given the following environment:

```bash
SETTINGS__SECTION__SERVER_SIZE=1
SETTINGS__SECTION__SERVER=google.com
SETTINGS__SECTION__SSL_ENABLED=false
```

And the following configuration:

```ruby
Config.setup do |config|
  config.use_env = true
  config.env_prefix = 'SETTINGS'
  config.env_separator = '__'
  config.env_converter = :downcase
  config.env_parse_values = true
end
```

The following settings will be available:

```ruby
Settings.section.server_size # => 1
Settings.section.server # => 'google.com'
Settings.section.ssl_enabled # => false
```

### Working with AWS Secrets Manager

It is possible to parse variables stored in an AWS Secrets Manager Secret as if they were environment variables by using `Config::Sources::EnvSource`.

For example, the plaintext secret might look like this:

```json
{
  "Settings.foo": "hello",
  "Settings.bar": "world",
}
```

In order to load those settings, fetch the settings from AWS Secrets Manager, parse the plaintext as JSON, pass the resulting `Hash` into a new `EnvSource`, load the new source, and reload.

```ruby
# fetch secrets from AWS
client = Aws::SecretsManager::Client.new
response = client.get_secret_value(secret_id: "#{ENV['ENVIRONMENT']}/my_application")
secrets = JSON.parse(response.secret_string)

# load secrets into config
secret_source = Config::Sources::EnvSource.new(secrets)
Settings.add_source!(secret_source)
Settings.reload!
```

In this case, the following settings will be available:

```ruby
Settings.foo # => "hello"
Settings.bar # => "world"
```

By default, `EnvSource` will use configuration for `env_prefix`, `env_separator`, `env_converter`, and `env_parse_values`, but any of these can be overridden in the constructor.

```ruby
secret_source = Config::Sources::EnvSource.new(secrets,
                                               prefix: 'MyConfig',
                                               separator: '__',
                                               converter: nil,
                                               parse_values: false)
```

## Contributing

You are very warmly welcome to help. Please follow our [contribution guidelines](CONTRIBUTING.md)

Any and all contributions offered in any form, past present or future are understood to be in complete agreement and acceptance with [MIT](LICENSE) license.

### Running specs

Setup

```sh
bundle install
bundle exec appraisal install
```

List defined appraisals:

```sh
bundle exec appraisal list
```

Run specs for specific appraisal:

```sh
bundle exec appraisal rails-6.1 rspec
```

Run specs for all appraisals:

```sh
bundle exec appraisal rspec
```

## Authors

* [Piotr Kuczynski](http://github.com/pkuczynski)
* [Fred Wu](http://github.com/fredwu)
* [Jacques Crocker](http://github.com/railsjedi)
* Inherited from [AppConfig](http://github.com/cjbottaro/app_config) by [Christopher J. Bottaro](http://github.com/cjbottaro)

## Contributors

### Code Contributors

This project exists thanks to all the people who contribute and you are very warmly welcome to help. Please follow our [contribution guidelines](CONTRIBUTING.md).

Any and all contributions offered in any form, past present or future are understood to be in complete agreement and acceptance with the [MIT](LICENSE) license.

[![Contributors](https://opencollective.com/rubyconfig/contributors.svg?width=890&button=false)](https://github.com/rubyconfig/config/graphs/contributors)

### Financial Contributors

[Become a backer](https://opencollective.com/rubyconfig#backer) and support us with a small monthly donation to help us continue our activities. Thank you if you already one! 🙏

[![Backers](https://opencollective.com/rubyconfig/backers.svg?width=890)](https://opencollective.com/rubyconfig)

#### Sponsors

Support this project by becoming a [sponsor](https://opencollective.com/rubyconfig#sponsor). Your logo will show up here with a link to your website.

[![Sponsors](https://opencollective.com/rubyconfig/sponsors.svg?width=890)](https://opencollective.com/rubyconfig)

## License

Copyright (C) Piotr Kuczynski. Released under the [MIT License](LICENSE.md).
