# 1.0.0

* `RailsConfig` is now officially renamed to `Config`
* Fixed array descent when converting to hash (thanks [@slicedpan](https://github.com/railsconfig/config/commit/c24d09907aeb09231586dc0914050fa7a05542e3))
* Catch OpenStruct reserved keywords (thanks [@dudo](https://github.com/railsconfig/config/commit/2bf3baf10590d56c6382d79e323dc11295d9e5c1))
* Allows loading before app configuration process (thanks [Andrey Voronkov](https://github.com/railsconfig/config/commit/8732c18d1fb9715554274543b707c1006daa50f5))
* `deep_merge` is now properly managed via gemspec (thanks [@firedev](https://github.com/railsconfig/config/commit/a2560bcec1a902a807d8c1766368906e5789a18e))
* Added `prepend_source!` (thanks [@eugenk](https://github.com/railsconfig/config/pull/102))
* Miscellaneous tweaks and fixes by @pkuczynski and co

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
