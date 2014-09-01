class SearchController < ApplicationController
  def results
    @query = params[:query]
    if @current_user
      @results = Swarm.unspiked.search_by_name_and_description(@query)
    else
      @results = Swarm.unspiked.publicly_visible.search_by_name_and_description(@query)
    end
  end
end
