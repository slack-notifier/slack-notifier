source 'https://rubygems.org'

gemspec

group :development do
  if RUBY_VERSION >= '2.0.0'
    gem 'pry-byebug'
  else
    gem 'pry-debugger'
  end
  gem 'wwtd'
  gem 'travis'
  gem 'benchmark-ips'
end

group :test do
  gem 'rake',  '~> 10.4'
  gem 'rspec', '~> 3.3.0'
end
