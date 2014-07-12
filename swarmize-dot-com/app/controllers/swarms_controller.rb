class SwarmsController < ApplicationController
  def index
    @swarms = Swarm.all
  end

  def show
    @swarm = Swarm.find(params[:id])
  end

  def new
  end
end
