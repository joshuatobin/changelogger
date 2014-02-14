require 'sinatra/base'
require 'json'
require 'sequel'

class ChangeLogger < Sinatra::Base

  before do
    content_type 'application/json'
  end

  DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://localhost/changelogger')

  # Support for PostgreSQL Json type 
  # http://sequel.jeremyevans.net/rdoc-plugins/files/lib/sequel/extensions/pg_json_rb.html
  DB.extension :pg_array, :pg_json

  get '/' do
    "Welcome to ChangeLogger!"
  end

  post '/changelogger' do
    content_type :json
    # We need to use rewind here or weird things happen when parsing the json
    request.body.rewind
    data = JSON.parse(request.body.read)

    begin
      status 200 if DB[:changelogger].insert(:created_at => Time.now, :log => Sequel.pg_json(data))
    rescue Sequel::Error => e
      halt(500, e)
    end
  end

  # TODO: Need to add some search funtionality to be able to search on the json types
  post '/search' do
  end

  # TODO: Returns the class object rather than the result. 
  # returns the last 60 days of changelogger events
  get '/events' do
    e = DB[:changelogger].order(:id)
    "#{e.limit(60)}"
  end

  # returns all changelogger events
  get '/events/all' do
    "#{DB[:changelogger].all}"
  end

  # returns the last changelogger event
  get '/events/last' do
    "#{DB[:changelogger].order(:id).last}"
  end
end





