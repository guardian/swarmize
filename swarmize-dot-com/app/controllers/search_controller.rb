class SearchController < ApplicationController
  def results
    @query = params[:query]
    if @current_user
      @swarms = Swarm.search_by_name_and_description(@query)
    else
      @swarms = Swarm.publicly_visible.search_by_name_and_description(@query)
    end
  end
end
