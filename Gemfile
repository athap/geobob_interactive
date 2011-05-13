source 'http://rubygems.org'

gem "rails", ">= 3.0.7"
gem "mysql"

gem "devise", ">= 1.1.3"
gem "cancan"
gem "hoptoad_notifier"
gem "jammit"
gem "friendly_id", "~> 3.1"
gem "will_paginate", "~> 3.0.pre2"
gem 'acts-as-taggable-on', '2.0.6'
gem 'uploader'
gem "overlord"
gem 'formtastic', '>= 1.1.0'
gem 'paperclip', '>=2.3.5'
gem 'sanitize', '1.2.1'
gem "aasm", '2.2.0'
gem 'geokit', '1.5.0'
gem 'rubyzip', '0.9.4'
gem 'tiny_mce', '0.1.3'

if RUBY_VERSION < '1.9'
  gem "ruby-debug"
end

group :test, :development, :cucumber do
  gem "rspec-rails", ">=2.0.0"
  gem "cucumber-rails"
  gem "factory_girl_rails"
  gem "database_cleaner"
  gem "timecop"
  gem "pickle"
end

group :cucumber do
  gem "cucumber"
  gem "cucumber-rails"
  gem "capybara", ">= 0.4.0"
  gem "launchy"
end

group :test do
  gem "autotest"
  gem "autotest-rails"
  gem "shoulda"
  gem "capybara", ">= 0.4.0"
  gem "factory_girl"
  gem "rcov"
  gem "rspec", ">=2.0.0"
  gem "database_cleaner"
  gem "spork"
  gem "faker"
end