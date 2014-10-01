require './lib/swarmize_search'
require './lib/dynamo_swarm'
require './lib/api_token'
require './lib/geo_json_formatter'
require 'json'

class SwarmizeApi < Sinatra::Base
  before do
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Allow-Methods'] = "GET, POST, PUT, DELETE, OPTIONS"
    headers['Access-Control-Allow-Headers'] ="accept, authorization, origin"
  end

  def check_permissions
    api_token = params[:api_token]
    swarm_token = params[:token]

    unless APIToken.exists_for_swarm(api_token, swarm_token)
      halt 403, "You don't have permission to do that."
    end
  end

  get '/swarms/:token' do
    check_permissions
    content_type :json

    swarm = DynamoSwarm.new(params[:token])
    swarm.definition.to_json
  end

  get '/swarms/:token/results' do
    check_permissions
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
    check_permissions
    content_type :json

    swarm = DynamoSwarm.new(params[:token])

    results = swarm.search.entirety
    if params[:format] == 'geojson'
      results = GeoJSONFormatter.format(results, {coords_key:params[:geo_json_point_key],
                                       properties_keys:params[:properties_keys]} )
    end
    results.to_json
  end

  get '/swarms/:token/counts' do
    # TODO: top-level counts
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
