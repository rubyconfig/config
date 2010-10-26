require "bundler"
Bundler.setup

require 'rake'
require 'rake/gempackagetask'

gemspec = eval(File.read('rails_config.gemspec'))
Rake::GemPackageTask.new(gemspec) do |pkg|
  pkg.gem_spec = gemspec
end

desc "build the gem and release it to rubygems.org"
task :release => :gem do
  puts "Tagging #{gemspec.version}..."
  system "git tag -a #{gemspec.version} -m 'Tagging #{gemspec.version}'"
  puts "Pushing to Github..."
  system "git push --tags"
  puts "Pushing to rubygems.org..."
  system "gem push pkg/#{gemspec.name}-#{gemspec.version}.gem"
end

require "rspec"
require "rspec/core/rake_task"

Rspec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

Rspec::Core::RakeTask.new('spec:progress') do |spec|
  spec.rspec_opts = %w(--format progress)
  spec.pattern = "spec/**/*_spec.rb"
end

require "rake/rdoctask"
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title = "Rails Config #{gemspec.version}"
  rdoc.rdoc_files.include("README*")
  rdoc.rdoc_files.include("lib/**/*.rb")
end


task :default => :spec
