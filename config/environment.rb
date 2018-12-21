# Configure environment as development
ENV['SINATRA_ENV'] ||= "development"

# Require bundled libraries
require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

# Establish a connection to a database, for the environment provided
ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
)

# Require application files
require './app/controllers/application_controller'
require_all 'app'

