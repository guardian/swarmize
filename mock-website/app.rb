require 'bundler/setup'
require 'sinatra/base'
require 'elasticsearch'
require 'jbuilder'
require 'hashie'

class MockSwarmizeWebsite < Sinatra::Base

  Swarm = Struct.new(:key, :name)
  swarm = Swarm.new("abc123", "Live Debate Swarm")

  # eg
  client = Elasticsearch::Client.new log: true, host: 'ec2-54-83-167-14.compute-1.amazonaws.com:9200'


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

    query = Jbuilder.encode do |json|
      json.size 10
      json.from 10 * (page-1)
      json.query do
        json.filtered do
          json.filter do
            json.terms do
              json.feedback %w{lab con ld}
            end
          end
        end
      end
      json.sort do
        json.timestamp "asc"
      end
    end

    search_results = client.search(index: 'voting', body: query)

    search_results_hash = Hashie::Mash.new(search_results)

    total_hits = search_results_hash.hits.total
    per_page = 10
    total_pages = (total_hits/per_page) + 1

    rows = search_results_hash.hits.hits.map {|h| h._source}

    haml :data, :locals => {:swarm => swarm, rows: rows, current_page: page, total_pages: total_pages}
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end

