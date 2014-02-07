require 'sinatra'
require 'json'
require 'data_mapper'
require 'dm-types'
require 'sinatra/json'

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

post '/test' do
  request.body.rewind
  data = JSON.parse(request.body.read)
  @log = Changelog.new(data)
  @log.save
end

get '/events' do
  "hello"
  p request.body
  content_type :json
  @events = Changelog.all(:order => :created_at.desc)
  @events.to_json
end

before do
  if request.request_method == "POST"
    body_parameters = request.body.read
    params.merge!(JSON.parse(body_parameters))
  end
end

post '/changelogger' do
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



