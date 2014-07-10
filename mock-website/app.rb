require 'bundler/setup'
require 'sinatra/base'
require './lib/swarm'
require './lib/display_field'
require './lib/swarmize_search'

class MockSwarmizeWebsite < Sinatra::Base

  swarm1 = Swarm.new(
    "voting", 
    "Live Debate Swarm",
     [
      ["timestamp", "Timestamp", 'timestamp'],
      ["postcode", "Postcode"],
      ["intent", "Intent"],
      ["feedback", "Feedback"],
      ["ip", "IP"],
      ["user_key", "User Key"]
    ]
  )

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

    rows, total_pages = swarm.search.all(page)

    haml :show, :locals => {:swarm => swarm, rows: rows, current_page: page, total_pages: total_pages}
  end

  get '/swarms/:key/graphs/count/:count_field' do
    swarm = swarms.find {|s| s.key == params[:key]}

    swarm.search.aggregate_count(params[:count_field]).map do |hash|
      { label: hash.keys.first,
        value: hash.values.first
      }
    end.to_json
  end

  get '/swarms/:key/graphs/count/:count_field/:unique_field' do
    swarm = swarms.find {|s| s.key == params[:key]}
    swarm.search.cardinal_count(params[:count_field], params[:unique_field]).map do |hash|
      {
        label: hash.keys.first,
        value: hash.values.first
      }
    end.to_json
  end

  get '/playground' do
    haml :playground
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
