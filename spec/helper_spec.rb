ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'
require 'rack/test'

$LOAD_PATH << File.expand_path('../lib', __FILE__)

