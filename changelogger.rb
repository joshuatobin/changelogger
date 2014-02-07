require 'sinatra'
require 'json'
require 'data_mapper'
require 'dm-types'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite")

class Changelog
  include DataMapper::Resource
  property :id, Serial 
  property :log, Text
  property :created_at, DateTime

  def url
    "changelogger/#{id}"
  end
end

DataMapper.finalize
DataMapper.auto_upgrade!

#get '/' do
#  redirect to('/events')
#end

get '/events' do
  "hello"
  p request.body
  content_type :json
  @events = Changelog.all(:order => :created_at.desc)
  @events.to_json
end

# Problem -- I want to send the changelogger random blobs of JSON and have it store it in the log field. 
# Ex: curl -i -X POST -H "Accept: application/json" -H "Content-type: application/json" -d '{"log": "service"}' localhost:5000/changelogge
# The json is being sent in the body of the post. We can use JSON.parse to pull out the data into a hash, however saving it in the db always results in null.
# Since the json is in the body, its not available as a param. There seems to be various methods for serializing/de-serializing but none seems to work. 

# Adding middleware might be one way to solve adding JSON POST'd body to the params hash. 
# https://github.com/mattt/sinatra-param/pull/8
# or maybe by using rack::parser, which is basically populating env[rack.request.form_hash] with a hash and then exposing it through params hash.
# http://recipes.sinatrarb.com/p/middleware/rack_parser

# dm-types claims it can load/dump but failures occur.
# dm-types http://datamapper.org/docs/dm_more/types.html

# post '/changelogger' do
#   # params[:log] will be null since json isn't available in params
#   changelogger = Changelog.new(params[:log])
#   if changelogger.save
#     status 201
#     response['Location'] = changelogger.url
#   else
#     status 422
#     changelogger.errors.values.join
#   end
# end

# Will transform json into hash -- {"log"=>"service"}:Hash
# How do I save this hash into data_mapper. I've tried adding the dm-types 'Json' property to the log field but wont accept the hash.

before do
  if request.request_method == "POST"
    body_parameters = request.body.read
    params.merge!(JSON.parse(body_parameters))
  end
end

post '/changelogger' do
  content_type :json
  changelogger = Changelog.new(params)
  if changelogger.save
    status 201
    response['Location'] = changelogger.url
  else
    status 422
    changelogger.errors.values.join
  end
end
 
# Example of POST 
#post '/changelogger' do
#  content_type :json
#  log = JSON.parse(request.body.read)
#  log.to_json
#end



