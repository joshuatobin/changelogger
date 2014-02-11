require 'sinatra/base'
require 'json'
require 'sequel'

class ChangeLogger < Sinatra::Base
  DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://localhost/changelogger')

  # Support for PostgreSQL Json type 
  # http://sequel.jeremyevans.net/rdoc-plugins/files/lib/sequel/extensions/pg_json_rb.html
  DB.extension :pg_array, :pg_json

  # Need to figure out where this is suppossed to live. 
  DB.create_table :changelogger do
    primary_key :id
    String :service
    Json :log
  end

  get '/' do
    "Welcome to ChangeLogger!"
  end

  post '/changelogger' do
    # We need to use rewind here or weird things happen when parsing the json
    request.body.rewind
    data = JSON.parse(request.body.read)

    # Returns a object of Sequel::Postgres::JSONHash
    # x = Sequel.pg_json(data)
    # "#{x.class}"
    
    status 200 if DB[:changelogger].insert(:log => Sequel.pg_json(data))
  end

  # returns all events
  get '/events' do
    "#{DB[:changelogger].all}"
  end
end





