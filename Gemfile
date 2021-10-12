# frozen_string_literal: true

source "https://rubygems.org"

gemspec

group :development do
  gem "pry-byebug" if RUBY_PLATFORM != "java"
  gem "benchmark-ips"
end

group :test do
  gem "rake"
  gem "rspec"
  gem "rubocop"
end
