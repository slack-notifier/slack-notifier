source 'https://rubygems.org'

gemspec

group :development do
  if RUBY_VERSION >= '2.0.0'
    gem 'pry-byebug'
  else
    gem 'pry-debugger'
  end

  gem 'benchmark-ips'
end

group :test do
  gem 'rake',     '~> 10.4'
  gem 'rspec',    '~> 3.3.0'
  gem 'rubocop',  '~> 0.35', require: false

  if RUBY_VERSION <= '1.9.3'
    gem 'string-scrub'
  end
end
