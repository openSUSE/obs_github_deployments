# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"
Dir["tasks/*.rake"].each { |t| load t }

RuboCop::RakeTask.new do |task|
  task.requires << "rubocop-rake"
  task.requires << "rubocop-rspec"
end

task default: %i[spec rubocop]
