class SearchController < ApplicationController
  def results
    @query = params[:query]
    @results = Swarm.unspiked.search_by_name_and_description(@query)
  end
end
