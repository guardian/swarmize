require './lib/swarmize_search'
require './lib/dynamo_swarm'
require './lib/api_key'
require './lib/geo_json_formatter'
require 'json'

class SwarmizeApi < Sinatra::Base
  before do
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Allow-Methods'] = "GET, POST, PUT, DELETE, OPTIONS"
    headers['Access-Control-Allow-Headers'] ="accept, authorization, origin"
  end

  def check_permissions
    api_key = params[:api_key]
    swarm_token = params[:token]

    unless APIKey.exists_for_swarm(api_key, swarm_token)
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

  get '/swarms/:token/latest' do
    check_permissions
    content_type :json

    swarm = DynamoSwarm.new(params[:token])

    latest = swarm.search.latest
    latest.to_json
  end

  get '/swarms/:token/entirety' do
    check_permissions
    content_type :json

    swarm = DynamoSwarm.new(params[:token])

    results = swarm.search.entirety
    if params[:format] == 'geojson'
      results = GeoJSONFormatter.format(results, params[:geo_json_point_key])
    end
    results.to_json
  end

  get '/swarms/:token/counts' do
    check_permissions
    content_type :json

    swarm = DynamoSwarm.new(params[:token])
    
    countable_fields = %w{pick_one pick_several rating yesno check_box}
    swarm_countable_fields = swarm.definition['fields'].select {|f| countable_fields.include? f['field_type']}

    results = swarm_countable_fields.each do |field|
      counts = swarm.search.aggregate_count(field['field_name_code'])
      field[:counts] = counts
      field
    end

    results.to_json
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
