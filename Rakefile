require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

RuboCop::RakeTask.new

RSpec::Core::RakeTask.new(:spec) do |r|
  r.pattern = FileList['spec/*_spec.rb']
end

task ci: [:spec, :rubocop]
