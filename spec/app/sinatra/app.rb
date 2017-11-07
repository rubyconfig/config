require 'sinatra'
require File.expand_path('../../../../lib/config', __FILE__)

set :root, File.dirname(__FILE__)
register Config

get '/' do
  'Hello world!'
end
