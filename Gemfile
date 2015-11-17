source 'https://rubygems.org'
ruby '2.1.7'

gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bcrypt'
gem 'fabrication'
gem 'faker'
gem 'sidekiq'
gem 'puma'
gem 'sentry-raven'
gem 'carrierwave'
gem 'mini_magick'
gem 'figaro'
gem 'stripe'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'letter_opener'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'launchy'
  gem 'capybara-email'
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver'
  gem 'database_cleaner', '1.4.1'
end

group :staging, :production do
  gem 'carrierwave-aws'
end

group :production do
  gem 'rails_12factor'
end

