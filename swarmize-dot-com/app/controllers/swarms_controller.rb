class SwarmsController < ApplicationController
  def index
    @swarms = Swarm.all
  end

  def show
    @swarm = Swarm.find(params[:id])
  end

  def fields
    @swarm = Swarm.find(params[:id])
  end

  def new
    @swarm = Swarm.new
  end

  def create
    Swarm.create(swarm_params)
    redirect_to swarms_path
  end

  def update_fields
    render :text => params.inspect

  end

  private

  def swarm_params
    params.require(:swarm).permit(:name, :description)
  end
end
