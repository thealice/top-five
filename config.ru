require './config/environment'

if ActiveRecord::Base.connection.migration_context.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

# Send PATCH and DELETE requests
use Rack::MethodOverride

# Mount controllers
run ApplicationController
use ListsController
use UsersController