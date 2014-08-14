require 'bundler/setup'
require 'sinatra/base'
require './lib/swarm_api'

class LiveDebate < Sinatra::Base
  enable :sessions
  set :sessions, :expire_after => 2592000

  swarm = SwarmApi.new("dcucpwlm")

  get '/' do
    unless session[:unique_key]
      session[:unique_key] = (Time.now.to_f * 10000000).to_i
    end

    haml :index, :locals => {:key => session[:unique_key]}
  end

  post '/endpoint' do
    data = params.merge(:unique_user_key => session[:unique_key])

    # now send that to Swarm
    swarm.send(data)
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end

