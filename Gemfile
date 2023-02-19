source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '>= 2.3.8', '< 2.4' # must be < 2.4 until we upgrade to Rails >= 4.2.8 (see https://rubyonrails.org/2017/2/21/Rails-4-2-8-has-been-released)

gem 'rails', '4.1.16'

gem 'devise', '~> 3.2.2'
gem 'psych', '~> 2.0.2' # part of stdlib, need newer version for safe_load

# change back to cookie-based store (encrypted)
gem 'activerecord-session_store'

gem 'rubyzip', '1.3.0'

gem 'jquery-rails', '~> 3.1.3'
gem 'jquery-ui-rails', '4.0.5'
gem 'jquery-historyjs', '0.2.3'
gem 'superfish-rails', '~> 1.6.0'

gem 'nokogiri', '~> 1.10.8'
gem 'redcarpet'
gem 'rmagick'
gem 'carrierwave'
gem 'will_paginate'
gem 'has_scope'
gem 'pundit'
gem 'recaptcha', :require => 'recaptcha/rails'
gem 'loofah'
gem 'whenever', :require => false # for cron jobs
gem 'squeel'#, '~> 1.1.1' # until version 1.1.2 released
gem 'tilt'
gem 'simple-navigation', '3.11.0'
gem 'simple_form', '3.2.1'
gem 'facebox-rails'
gem 'strong_presenter', '~> 0.2.2'
gem 'render_anywhere'
gem 'pygments.rb', '~> 1.1.0'
gem 'ranked-model'
gem 'pdf-reader'
gem 'mechanize'
gem 'prawn'
gem 'rqrcode'
gem 'pdfkit'

gem 'countries'
gem 'country_select'
gem 'world-flags'
gem 'jquery-final_countdown-rails'
gem 'ruby-duration'

gem 'pg'
gem 'backup'

# Redis and Background Processing
gem 'redis', '< 4.0'
gem 'qless'#, :github => 'ronalchn/qless', :branch => 'nztrain'
gem 'connection_pool'
gem 'sinatra'

# Deploy with Capistrano
# gem 'capistrano'

# Monitoring
gem 'newrelic_rpm'
gem 'coveralls', require: false

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'foreman'
  gem 'spring'
end

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'capybara'
  gem 'capybara-email'

  gem 'factory_bot_rails'

  gem 'byebug'

  gem 'ruby_parser' # for declarative_authorization
end


# Gems used only for assets and not required  
# in production environments by default.  
#group :assets do  
gem 'sass'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier', '>=1.0.3'
gem 'libv8', '~> 3.3'
gem 'therubyracer', '~> 0.11' # required for the execjs gem (dependency)
gem 'yui-compressor'
#end



