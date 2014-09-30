require './lib/swarmize_search'
require './lib/dynamo_swarm'
require 'json'

class SwarmizeApi < Sinatra::Base
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

  get '/swarms/:token/counts' do
    # TODO: top-level counts
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
