class SearchController < ApplicationController
  def results
    @query = params[:query]
    @results = Swarm.search_by_name_and_description(@query)
  end
end
