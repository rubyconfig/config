# 1.1.0

* Add ability to specify knockout_prefix option for deep_merge
* Minor code and documentation refactoring and cleanup

# 1.0.0

* `RailsConfig` is now officially renamed to `Config`
* Fixed array descent when converting to hash ([#89](https://github.com/railsconfig/config/pull/89))
* Catch OpenStruct reserved keywords ([#95](https://github.com/railsconfig/config/pull/95) thanks @dudo)
* Allows loading before app configuration process ([#107](https://github.com/railsconfig/config/pull/107) thanks @Antiarchitect)
* `deep_merge` is now properly managed via gemspec ([#110](https://github.com/railsconfig/config/pull/110))
* Added `prepend_source!` ([#102](https://github.com/railsconfig/config/pull/102))

# 0.99
* Released deprecated gem migrating to the new name

# 0.5.0.beta1

* Ability to use in Settings file keywords reserved for OpenStruct: select, collect ([#95](https://github.com/railsjedi/config/issues/95))
* Made config work without Rails as a hard dependency ([#86](https://github.com/railsjedi/config/issues/86), [#88](https://github.com/railsjedi/config/issues/88))
* Fix generate error when .gitignore is missing ([#85](https://github.com/railsjedi/config/issues/85))
* Fix deprecation warning on File.exists? ([#81](https://github.com/railsjedi/config/issues/81))
* Add a shortcut method for setting files ([#67](https://github.com/railsjedi/config/issues/67))
* Improve YAMLSource load error message by outputting offending file path ([#88](https://github.com/railsjedi/config/issues/88))

# 0.4.2
* Ability to specify the app name when calling the Heroku rake task ([#75](https://github.com/railsjedi/config/issues/75))

# 0.4.1

* Fixed compatibility with Rails 4.1 ([#72](https://github.com/railsjedi/config/issues/72))
* Testing suite verifies compatibility with Rails 3.2, 4.0 and 4.1

# 0.4.0

* Compatibility with Heroku ([#64](https://github.com/railsjedi/config/issues/64))

# 0.3.4

* Expose Settings in application.rb, so you don't have to duplicate configuration for each environment file ([#59](https://github.com/railsjedi/config/issues/59))
* Adding support for Rails 4.1.0.rc ([#70](https://github.com/railsjedi/config/issues/70))



