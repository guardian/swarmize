require 'bundler/setup'
require 'sinatra/base'
require './lib/swarm'
require './lib/swarmize_search'

class MockSwarmizeWebsite < Sinatra::Base

  swarm1 = Swarm.new("voting", "Live Debate Swarm")
  swarms = [swarm1]

  helpers do
    def format_timestamp(ts)
      t = Time.at(ts / 1000 / 1000)
      t.strftime("%d %B %Y %H:%M:%S")
    end
  end

  get '/' do
    haml :index, :locals => {:swarms => swarms}
  end

  get '/swarms/:key' do
    swarm = swarms.find {|s| s.key == params[:key]}
    if params[:page]
      page = params[:page].to_i
    else
      page = 1
    end

    rows, total_pages = SwarmizeSearch.all(page)

    haml :show, :locals => {:swarm => swarm, rows: rows, current_page: page, total_pages: total_pages}
  end

  get '/graphs/all_feedback' do
    SwarmizeSearch.aggregate_feedback.map do |hash|
      { label: hash.keys.first,
        value: hash.values.first
      }
    end.to_json
  end

  get '/graphs/all_intent' do
    SwarmizeSearch.aggregate_intent.map do |hash|
      {
        label: hash.keys.first,
        value: hash.values.first
      }
    end.to_json
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end

