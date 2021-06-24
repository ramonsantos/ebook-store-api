# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'bootsnap', '>= 1.4.4', require: false
gem 'devise', '~> 4.7', '>= 4.7.2'
gem 'devise-jwt', '~> 0.8.0'
gem 'jsonapi-serializer'
gem 'kaminari'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'pundit'
gem 'rack-cors'
gem 'rails', '~> 6.1.1'
gem 'versionist'

group :development, :test do
  gem 'amazing_print'
  gem 'factory_bot_rails', '~> 6.1'
  gem 'pry-byebug'
  gem 'pry-rails'
end

group :development do
  gem 'brakeman', '~> 5.0', '>= 5.0.4'
  gem 'listen', '~> 3.3'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'spring'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec-rails', '~> 4.0', '>= 4.0.2'
  gem 'shoulda-matchers', '~> 4.5', '>= 4.5.1'
  gem 'simplecov', '0.17.1'
end
