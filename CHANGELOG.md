# Changelog

## 4.1.0

### Bug fixes

* Only load `Railtie` integration if `Rails::Railtie` is defined ([#319](https://github.com/rubyconfig/config/pull/319))
* Fix indentation warning in Ruby 3.1 ([#322](https://github.com/rubyconfig/config/pull/322))

## 4.0.0

### BREAKING CHANGES

* Rails versions `< 5.2` are no longer supported ([#316](https://github.com/rubyconfig/config/pull/316))
* Ruby versions `< 2.6` are no longer supported ([#316](https://github.com/rubyconfig/config/pull/316))
* Support `HashSource` and `EnvSource` instances in `Config.load_files` and `Config.load_and_set_settings`. ([#315](https://github.com/rubyconfig/config/pull/315)). There are a few subtle breaking changes:
  * Previously, `Config.load_files` (called from `Config.load_and_set_settings`) would call `.to_s` on each of its arguments. Now, this responsibility is defered to YAMLSource. In effect, if your application passes String or Pathname objects to `Config.load_files`, no changes are necessary, but if you were somehow relying on the `.to_s` call for some other type of object, you'll now need to call `.to_s` on that object before passing it to `Config`.
  * Before this change, `Config.load_files` would call `uniq` on its argument array. This call has been removed, so duplicate file paths are not removed before further processing. In some cases, this can cause differences in behavior since later config files override the values in earlier ones. In most cases, it's best to ensure that duplicate paths are not passed to `Config.load_files`.

## 3.1.1

### Bug fixes

* Allow the use of unsafe YAML parsing features when using psych >= 4 ([#306](https://github.com/railsconfig/config/issues/306))

## 3.1.0

### New features

* Evaluating ERB in YAML files can now be disabled with `Config.evaluate_erb_in_yaml = false`. The default value for this option is `true` for backwards-compatibility. ([#303](https://github.com/rubyconfig/config/pull/303))

## 3.0.0

### BREAKING CHANGES

* After upgrade behaviour of `to_h` would change and match behaviour of `to_hash`. Check [#217](https://github.com/rubyconfig/config/issues/217#issuecomment-741953382) for more details.
* `Config::Options#load_env!` and `Config::Options#reload_env!` have been removed. If you need to reload settings after modifying the `ENV` hash, use `Config.reload!` or `Config::Options#reload!` instead.

### Bug fixes

* Added alias `to_h` for `to_hash` ([#277](https://github.com/railsconfig/config/issues/277))

### Changes

* Add `Config::Sources::EnvSource` for loading settings from flat `Hash`es with `String` keys and `String` values, such as from AWS SecretsManager ([#299](https://github.com/railsconfig/config/pull/299))

## 2.2.3

### Bug fixes

* Revert added alias to_h for to_hash ([#277](https://github.com/railsconfig/config/issues/277))

### Changes

* Raise explicit error on environment variable conflicts ([#293](https://github.com/railsconfig/config/issues/293))

## 2.2.2

### Bug fixes

* Added alias to_h for to_hash ([#277](https://github.com/railsconfig/config/issues/277))
* Prevent unnecessary doubled loading of environment variables ([#291](https://github.com/rubyconfig/config/pull/291))
* Return `Hash` from `Config::Options#as_json` instead of `Array` of pairs when using ActiveSupport Core Extensions ([#292](https://github.com/rubyconfig/config/pull/292))

### Changes

* Add JRuby 9.2 to the test matrix ([#228](https://github.com/railsconfig/config/issues/228))
* Add exit! to reserved keywords ([#289](https://github.com/railsconfig/config/issues/289))

## 2.2.1

### Performance improvements

* Get rid of unused Rails Engine class definition ([#247](https://github.com/rubyconfig/config/pull/247))
* Require dry-validation only when schema is specified ([#253](https://github.com/rubyconfig/config/pull/253))
* Defer modification of `ActionController::Base` to when it is loaded in Rails integration ([#250](https://github.com/rubyconfig/config/pull/250))

### Bug fixes

* Fix missing new_ostruct_member in Ruby 2.7 ([#255](https://github.com/rubyconfig/config/pull/255))
* Fix validation contract documentation ([#260](https://github.com/rubyconfig/config/pull/260))
* Excluded test application's *.md files from the gem build ([#267](https://github.com/rubyconfig/config/pull/267))

### Changes

* Use sprockets 3.x when running unit tests for Rails 4.2 ([#256](https://github.com/rubyconfig/config/pull/256))
* Cleanup example Rails application used for testing ([#263](https://github.com/rubyconfig/config/pull/263))
* Upgrade markdown linter and fix errors ([#265](https://github.com/rubyconfig/config/pull/265))
* Upgrade development dependencies and test matrix with latest Ruby and Rails versions ([#264](https://github.com/rubyconfig/config/pull/264))
* Replace Travis CI with GitHub Actions ([#266](https://github.com/rubyconfig/config/pull/266))
* Add Rails 6.0 to the test matrix ([#258](https://github.com/rubyconfig/config/pull/258))
* Rename GitHub organization name from `railsconfig` to `rubyconfig` ([#268](https://github.com/rubyconfig/config/pull/268))

## 2.1.0

### New features

* Add dry-validation contract support ([#238](https://github.com/rubyconfig/config/pull/238))

### Changes

* Get rid of activesupport dependency ([#230](https://github.com/rubyconfig/config/pull/230))
* Ignore .local files in test environment ([#135](https://github.com/rubyconfig/config/issues/135), [#233](https://github.com/rubyconfig/config/pull/233))
* Execute default rspec against latest Rails app and load appropriate development dependencies dynamically ([#241](https://github.com/rubyconfig/config/pull/241))
* Fix inconsistent documentation for ENV prefix and default value in generator ([#246](https://github.com/rubyconfig/config/pull/246))

### Bug fixes

* Fix warnings when running tests in Rails 5 scope ([#240](https://github.com/rubyconfig/config/issues/240)
* Do not run incompatible code coverage on truffleruby ([#242](https://github.com/rubyconfig/config/issues/242)

## 2.0.0

### BREAKING CHANGES

After upgrade to dry-schema 1.0 we had to drop support for Rails `< 4.2` and Ruby `< 2.4`.
If you need older version of Ruby or Rails, please stick to 1.x version of this gem.

### New features

* Add `merge_hash_arrays` as a configuration option ([#214](https://github.com/rubyconfig/config/pull/214))

### Changes

* Upgraded dry-validation dependency to dry-schema 1.0 ([#224](https://github.com/rubyconfig/config/pull/224))
* Moved constant to be defined on `Object` instead of `Kernel` ([#227](https://github.com/rubyconfig/config/issues/227))
* Add TruffleRuby to the test matrix ([#229](https://github.com/rubyconfig/config/issues/229))

## 1.7.2

### Bug fixes

* Lock max version of dry-validation depending on the ruby version ([#223](https://github.com/rubyconfig/config/pull/223))

## 1.7.1

### New features

* Upgrade dependencies ([#211](https://github.com/rubyconfig/config/pull/211))

### Changes

* Add Ruby 2.5 and Rails 5.1 to the testing matrix on Travis ([#201](https://github.com/rubyconfig/config/pull/201))
* Add Ruby 2.6 to the test matrix ([#210](https://github.com/rubyconfig/config/pull/210))
* Add Rails 5.2 to the test matrix ([#212](https://github.com/rubyconfig/config/pull/212))

## 1.7.0

### New features

* **WARNING:** `nil` values will from now on overwrite an existing value when merging configs! This change of behavior can be reverted via `config.merge_nil_values = false` in your Config initializer ([#196](https://github.com/rubyconfig/config/pull/196))

## 1.6.1

### Bug fixes

* Make dry-validation dependency less strict allowing to use newer versions ([#183](https://github.com/rubyconfig/config/pull/183))
* Fix `key?` and `has_key?`, which raise NoMethodError in non Rails environment, by using ActiveSupport `#delegate` implicitly ([#185](https://github.com/rubyconfig/config/pull/185))
* Update `deep_merge` dependency to latest version (v1.2.1) ([#191](https://github.com/rubyconfig/config/pull/191))
* Upgrade `rubocop` to version 0.52.1 ([#193](https://github.com/rubyconfig/config/pull/193))
* Add `zip` to the list of reserved keywords ([#197](https://github.com/rubyconfig/config/pull/197))

## 1.6.0

### New features

* `Config#fail_on_missing` option (default `false`) to raise a `KeyError` exception when accessing a non-existing key
* Add ability to test if a value was set for a given key with `key?` and `has_key?` ([#182](https://github.com/rubyconfig/config/pull/182))

## 1.5.1

### New features

* Add parsing of ENV variable values to Boolean type ([#180](https://github.com/rubyconfig/config/pull/180))

## 1.5.0

### New features

* Add ability to validate config schema ([#155](https://github.com/rubyconfig/config/pull/155) thanks to [@ok32](https://github.com/ok32))
* Add count to the reserved names list ([#167](https://github.com/rubyconfig/config/pull/167) thanks to [@carbonin](https://github.com/carbonin))

### Bug fixes

* Correctly parse `env_prefix`, which contains `env_separator` ([#177](https://github.com/rubyconfig/config/pull/177) thanks to [@rdodson41](https://github.com/rdodson41))

## 1.4.0

### New features

* Added support for passing a raw ruby hash into to both `Settings.add_source!` and `Settings.prepend_source!` ([#108](https://github.com/rubyconfig/config/pull/159) thanks to [@halloffame](https://github.com/halloffame))

### Bug fixes

* Added new reserved name `test` ([#158](https://github.com/rubyconfig/config/pull/158) thanks to [@milushov](https://github.com/milushov))
* `to_hash` should not replace nested config objects with Hash ([#160](https://github.com/rubyconfig/config/issues/160) thanks to [@seikichi](https://github.com/seikichi))

## 1.3.0

* **WARNING:** Overwrite arrays found in previously loaded settings file ([#137](https://github.com/rubyconfig/config/pull/137) thanks to [@Fryguy](https://github.com/Fryguy) and [@dtaniwaki](https://github.com/dtaniwaki)) - this is a change breaking previous behaviour. If you want to keep Config to work as before, which is merging arrays found in following loaded settings file, please add `config.overwrite_arrays = false` to your Config initializer
* Changed default ENV variables loading settings to downcase variable names and parse values
* Added parsing ENV variables values to Float type
* Change method definition order in Rails integration module to prevent undefined method `preload` error (based on [@YaroSpace](https://github.com/YaroSpace) suggestion in [#111](https://github.com/rubyconfig/config/issues/111)

## 1.2.1

* Fixed support for multilevel settings loaded from ENV variables (inspired by [@cbeer](https://github.com/cbeer) in [#144](https://github.com/rubyconfig/config/pull/144))

## 1.2.0

* Add ability to load settings from ENV variables ([#108](https://github.com/rubyconfig/config/issues/108) thanks to [@vinceve](https://github.com/vinceve) and [@spalladino](https://github.com/spalladino))
* Removed Rails 5 deprecation warnings for prepend_before_filter ([#141](https://github.com/rubyconfig/config/pull/141))

## 1.1.1

* Downgrade minimum ruby version to 2.0.0 ([#136](https://github.com/rubyconfig/config/issues/136))

## 1.1.0

* Add ability to specify knockout_prefix option for deep_merge
* Minor code and documentation refactoring and cleanup

## 1.0.0

* `rubyconfig` is now officially renamed to `Config`
* Fixed array descent when converting to hash ([#89](https://github.com/rubyconfig/config/pull/89))
* Catch OpenStruct reserved keywords ([#95](https://github.com/rubyconfig/config/pull/95) by [@dudo](https://github.com/dudo))
* Allows loading before app configuration process ([#107](https://github.com/rubyconfig/config/pull/107) by [@Antiarchitect](https://github.com/Antiarchitect))
* `deep_merge` is now properly managed via gemspec ([#110](https://github.com/rubyconfig/config/pull/110))
* Added `prepend_source!` ([#102](https://github.com/rubyconfig/config/pull/102))

## 0.99

* Released deprecated gem migrating to the new name

## 0.5.0.beta1

* Ability to use in Settings file keywords reserved for OpenStruct: select, collect ([#95](https://github.com/railsjedi/config/issues/95))
* Made config work without Rails as a hard dependency ([#86](https://github.com/railsjedi/config/issues/86), [#88](https://github.com/railsjedi/config/issues/88))
* Fix generate error when .gitignore is missing ([#85](https://github.com/railsjedi/config/issues/85))
* Fix deprecation warning on File.exists? ([#81](https://github.com/railsjedi/config/issues/81))
* Add a shortcut method for setting files ([#67](https://github.com/railsjedi/config/issues/67))
* Improve YAMLSource load error message by outputting offending file path ([#88](https://github.com/railsjedi/config/issues/88))

## 0.4.2

* Ability to specify the app name when calling the Heroku rake task ([#75](https://github.com/railsjedi/config/issues/75))

## 0.4.1

* Fixed compatibility with Rails 4.1 ([#72](https://github.com/railsjedi/config/issues/72))
* Testing suite verifies compatibility with Rails 3.2, 4.0 and 4.1

## 0.4.0

* Compatibility with Heroku ([#64](https://github.com/railsjedi/config/issues/64))

## 0.3.4

* Expose Settings in application.rb, so you don't have to duplicate configuration for each environment file ([#59](https://github.com/railsjedi/config/issues/59))
* Adding support for Rails 4.1.0.rc ([#70](https://github.com/railsjedi/config/issues/70))
