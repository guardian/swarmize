class SwarmsController < ApplicationController
  before_filter :scope_to_swarm, :except => %w{index new create}

  def index
    @swarms = Swarm.all
  end

  def show
  end

  def fields
  end

  def new
    @swarm = Swarm.new
  end

  def create
    Swarm.create(swarm_params)
    redirect_to swarms_path
  end

  def update_fields
    @swarm.update(:fields => params[:fields])
    redirect_to fields_swarm_path(@swarm)
  end

  private

  def scope_to_swarm
    @swarm = Swarm.find(params[:id])
  end

  def swarm_params
    params.require(:swarm).permit(:name, :description)
  end
end
