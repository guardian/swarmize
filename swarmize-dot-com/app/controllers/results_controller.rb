class ResultsController < ApplicationController
  before_filter :scope_to_swarm
  def show
    if params[:page]
      @current_page = params[:page].to_i
    else
      @current_page = 1
    end

    @rows, @total_pages = @swarm.search.all(@current_page, 10)
  end

  private

  def scope_to_swarm
    @swarm = Swarm.find(params[:id])
  end


end
