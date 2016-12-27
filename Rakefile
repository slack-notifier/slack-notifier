# frozen_string_literal: true

require "rubocop/rake_task"
require "rspec/core/rake_task"

rubocop = RuboCop::RakeTask.new
rubocop.fail_on_error = false
RSpec::Core::RakeTask.new(:spec)

task default: [:rubocop, :spec]
