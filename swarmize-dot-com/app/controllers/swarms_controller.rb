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

  def embed
    render layout: 'embed'
  end

  def new
    @swarm = Swarm.new
  end

  def edit
  end

  def create
    swarm = Swarm.create(swarm_params)
    redirect_to fields_swarm_path(swarm)
  end

  def update
    @swarm.update(swarm_params)
    if params[:update_and_next]
      redirect_to fields_swarm_path(@swarm)
    else
      redirect_to swarms_path
    end
  end

  def update_fields
    @swarm.update(:fields => params[:fields])
    if params[:update_and_next]
      redirect_to preview_swarm_path(@swarm)
    else
      redirect_to edit_swarm_path(@swarm)
    end
  end

  private

  def scope_to_swarm
    @swarm = Swarm.find(params[:id])
  end

  def swarm_params
    params.require(:swarm).permit(:name, :description)
  end
end
