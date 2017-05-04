require 'cookstyle'
require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

desc 'RuboCop compliancy checks'
RuboCop::RakeTask.new(:rubocop)

FoodCritic::Rake::LintTask.new do |t|
  t.options = {
    fail_tags: ['any'],
    tags: %w(
      ~FC070
    ),
  }
end

desc 'Run all linters on the codebase'
task :linters do
  Rake::Task['rubocop'].invoke
  Rake::Task['foodcritic'].invoke
end

# Rspec and ChefSpec
desc 'Run ChefSpec examples'
RSpec::Core::RakeTask.new(:spec)

task default: [:linters, :spec]
