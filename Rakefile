# frozen_string_literal: true

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

begin
  require "rubocop/rake_task"
  rubocop = RuboCop::RakeTask.new
  rubocop.fail_on_error = false
rescue LoadError
  task :rubocop do
    puts "Rubocop not loaded"
  end
end

task default: %i[spec rubocop]
