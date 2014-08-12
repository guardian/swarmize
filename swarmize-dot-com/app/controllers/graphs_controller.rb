class GraphsController < ApplicationController
  before_filter :scope_to_swarm

  def aggregate_count
    results = @swarm.search.aggregate_count(params[:count_field]).map do |hash|
      { label: hash.keys.first,
        value: hash.values.first
      }
    end
    
    render :json => results
  end

  def cardinal_count
    results = @swarm.search.cardinal_count(params[:count_field], params[:unique_field]).map do |hash|
      {
        label: hash.keys.first,
        value: hash.values.first
      }
    end

    render :json => results
  end

  private

  def scope_to_swarm
    @swarm = Swarm.find_by(token: params[:swarm_id])
  end
end
