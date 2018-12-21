# Load environment
require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

# Mount controllers. Run ApplicationController to start the app, and load the rest of the classes as middleware. Must run a valid sinatra controller (one that inherits from Sinatra::Base)
use Rack::MethodOverride
use SessionController
use UserController
use RoomController
use ProjectController
run ApplicationController
