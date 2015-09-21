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
  gem "table_print"
end

group :test do
  gem 'rake',  '~> 10.1'
  gem 'rspec', '~> 3.0.0'
end
