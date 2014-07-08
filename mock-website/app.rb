require 'bundler/setup'
require 'sinatra/base'
require './lib/swarmize_search'

class MockSwarmizeWebsite < Sinatra::Base

  Swarm = Struct.new(:key, :name)
  swarm = Swarm.new("abc123", "Live Debate Swarm")

  get '/' do
    haml :index, :locals => {:swarms => [swarm]}
  end

  get '/swarms/:key' do
    # live results page

    haml :show, :locals => {:swarm => swarm}
  end

  get '/swarms/:key/data' do
    if params[:page]
      page = params[:page].to_i
    else
      page = 1
    end

    rows, total_pages = SwarmizeSearch.all(page)

    haml :data, :locals => {:swarm => swarm, rows: rows, current_page: page, total_pages: total_pages}
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end

