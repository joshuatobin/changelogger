require File.expand_path '../helper_spec.rb', __FILE__

#require_relative '../helper_spec.rb'
require_relative '../changelogger.rb'

include Rack::Test::Methods

def app
  ChangeLogger
end

describe "ChangeLogger" do
  it "should return welcome response from index" do
    get '/'
    assert_equal "Welcome to ChangeLogger!", last_response.body
    last_response.status.must_equal 200
  end
  
  it "should successfully post json" do
    post '/changelogger', { :log => { "foo" => "baz" }}.to_json, "CONTENT_TYPE" => "application/json" 
    assert_equal(200, last_response.status)
    assert_equal('application/json;charset=utf-8',
                 last_response.content_type)
  end

  it "should return all events" do
    get '/events/all'
    assert_equal(200, last_response.status)
    assert_equal('application/json;charset=utf-8',
                 last_response.content_type)
  end

end



