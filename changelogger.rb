require 'sinatra'
require 'json'

get '/test.json' do
  content_type :json
  { :key1 => 'value1', :key2 => 'value4' }.to_json
end



