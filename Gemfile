source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
# Use postgresql as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# OpenAPI Documentation
gem 'open_api-rswag-api', '~> 0.1'
gem 'open_api-rswag-ui', '~> 0.1'

# Environment Variable management
gem 'dotenv-rails', '~> 2.7'

# HTTP Request wrapper
gem 'faraday', '~> 1.3'
gem 'faraday-http-cache', '~> 2.2'

# Easy Search Scoping
gem 'pg_search', '~> 2.3'

# JSON Serialization
gem 'blueprinter', '~> 0.25'

group :development, :test do
  gem 'pry-byebug'
  gem 'rspec'
  gem 'rspec-rails'
end

group :development do
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner'
  gem 'open_api-rswag-specs', '~> 0.1'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'timecop'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
