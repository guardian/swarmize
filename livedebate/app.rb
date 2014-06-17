require 'bundler/setup'
require 'sinatra/base'

class SwarmApi
  attr_reader :swarmkey, :hostname
  def initialize(swarmkey, hostname)
    @swarmkey = swarmkey
    @hostname = hostname
  end

  def send(data)
    # TODO: post this to hostname/swarm/key
    puts data.inspect
  end
end

class LiveDebate < Sinatra::Base
  enable :sessions
  set :sessions, :expire_after => 2592000

  swarm = SwarmApi.new("banana")

  get '/' do
    unless session[:unique_key]
      session[:unique_key] = (Time.now.to_f * 10000000).to_i
    end

    haml :index, :locals => {:key => session[:unique_key]}
  end

  post '/endpoint' do
    data = params.merge({:ip => request.ip, :user_key => session[:unique_key], :timestamp => (Time.now.to_f * 1000000).to_i})

    # now send that to Swarm
    swarm.send(data)
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end

