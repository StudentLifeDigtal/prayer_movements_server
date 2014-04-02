source 'https://rubygems.org'

# Server
gem 'rails'
gem 'puma'

# Database
gem 'pg'
gem 'activerecord'

# API
gem 'grape'
gem 'grape-swagger'
gem 'grape-kaminari'
gem 'grape-entity'

# Authentication & Authorization
gem 'devise'
gem 'doorkeeper'
gem 'rack-oauth2'
gem 'cancan'

gem 'airbrake'

group :development, :test do
  gem 'jazz_hands'
  gem 'rspec-rails', '~> 2.0'
  gem 'factory_girl_rails', :require => false
end

group :development do
  gem 'rails-erd'
  gem 'better_errors'
  gem 'dotenv-rails'
  gem 'binding_of_caller'
  gem 'guard'
  gem 'guard-spork'
  gem 'guard-bundler'
  gem 'guard-rspec'
end

group :test do
  gem 'grape-entity-matchers'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'selenium-webdriver'
  gem 'oauth2'
  gem 'fuubar'
  gem 'simplecov', :require => false
end