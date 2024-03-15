# Contributing

Install appraisal

```bash
gem install bundler
gem install appraisal
```

Bundle

```bash
bundle install
```

Bootstrap

```bash
bundle exec appraisal install
```

If you need to create new test app for specific rails version

```bash
bundle exec appraisal rails-7.0 rails new spec/app/rails_7.0
```

Run the test suite:

```bash
bundle exec appraisal rspec
```

If you modified any of the documentation files verify their format:

```bash
mdl *.md
```
