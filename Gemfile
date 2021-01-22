# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'bootsnap', '>= 1.4.4', require: false
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.1'

group :development, :test do
  gem 'factory_bot_rails', '~> 6.1'
  gem 'pry-byebug'
  gem 'pry-rails'
end

group :development do
  gem 'brakeman'
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
