class SwarmsController < ApplicationController
  before_filter :scope_to_swarm, :except => %w{index new create}

  respond_to :html, :json

  def index
    @swarms = Swarm.all
  end

  def show
    respond_with @swarm
  end

  def delete

  end

  def destroy
    @swarm.destroy
    redirect_to swarms_path
  end

  def fields
  end

  def preview
  end

  def new
    @swarm = Swarm.new
  end

  def edit
  end

  def create
    Swarm.create(swarm_params)
    redirect_to swarms_path
  end

  def update
    @swarm.update(swarm_params)
    redirect_to swarms_path
  end

  def update_fields
    @swarm.update(:fields => params[:fields])
    redirect_to preview_swarm_path(@swarm)
  end

  private

  def scope_to_swarm
    @swarm = Swarm.find(params[:id])
  end

  def swarm_params
    params.require(:swarm).permit(:name, :description)
  end
end
