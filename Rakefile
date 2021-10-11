# frozen_string_literal: true

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"
RuboCop::RakeTask.new

tasks = if RUBY_VERSION >= "2.3.0"
          %i[spec rubocop]
        else
          %i[spec]
        end

task default: tasks
