require './lib/swarmize_search'
require './lib/dynamo_swarm'
require './lib/geo_json_formatter'
require 'json'

class SwarmizeApi < Sinatra::Base
  before do
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Allow-Methods'] = "GET, POST, PUT, DELETE, OPTIONS"
    headers['Access-Control-Allow-Headers'] ="accept, authorization, origin"
  end

  get '/swarms/:token' do
    content_type :json

    swarm = DynamoSwarm.new(params[:token])
    swarm.definition.to_json
  end

  get '/swarms/:token/results' do
    # TODO: paginated results
    content_type :json

    swarm = DynamoSwarm.new(params[:token])

    if params[:page]
      page = params[:page].to_i 
    else
      page = 1
    end

    if params[:per_page]
      per_page = params[:per_page].to_i 
    else
      per_page = 10
    end

    results, total_count = swarm.search.all(page, per_page)
    output = {
      query_details: {
        per_page: per_page,
        page: page,
        total_pages: total_count
      },
      results: results
    }
    output.to_json
  end

  get '/swarms/:token/entirety' do
    content_type :json

    swarm = DynamoSwarm.new(params[:token])

    results = swarm.search.entirety
    if params[:format] == 'geojson'
      results = GeoJSONFormatter.format(results, params[:geo_json_point_key])
    end
    results.to_json
  end

  get '/swarms/:token/counts' do
    # TODO: top-level counts
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
