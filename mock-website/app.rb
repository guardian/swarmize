require 'bundler/setup'
require 'sinatra/base'
#require 'elasticsearch'

class MockSwarmizeWebsite < Sinatra::Base

  Swarm = Struct.new(:key, :name)
  swarm = Swarm.new("abc123", "Live Debate Swarm")

  # eg
  #client = Elasticsearch::Client.new log: true, host: 'hostname.com:9200'
  #client = Elasticsearch::Client.new log: true
  
  get '/' do
    haml :index, :locals => {:swarms => [swarm]}
  end

  get '/swarms/:key' do
    # live results page

    haml :show, :locals => {:swarm => swarm}
  end

  get '/swarms/:key/data' do
    # static page

    haml :data, :locals => {:swarm => swarm}
  end

  # start the server if ruby file executed directly
  #run! if app_file == $0
end

