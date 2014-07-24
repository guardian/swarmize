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
    redirect_to fields_swarm_path(@swarm)
  end

  def update_fields
    @swarm.update(:fields => params[:fields])
    if params[:update_and_next]
      redirect_to preview_swarm_path(@swarm)
    else
      redirect_to edit_swarm_path(@swarm)
    end
  end

  def open
    open_time = Time.new(params['open_year'],
                         params['open_month'],
                         params['open_day'],
                         params['open_hour'],
                         params['open_minute'])
    @swarm.update(:opens_at => open_time)
    redirect_to @swarm
  end

  def close
    close_time = Time.new(params['close_year'],
                          params['close_month'],
                          params['close_day'],
                          params['close_hour'],
                          params['close_minute'])

    if @swarm.opens_at && (@swarm.opens_at > close_time)
      flash[:error] = "Swarm cannot close before it has opened!"
    else
      @swarm.update(:closes_at => close_time)
    end
    redirect_to @swarm
  end

  def clone
    new_swarm = @swarm.dup
    new_swarm.opens_at = nil
    new_swarm.closes_at = nil
    new_swarm.name = @swarm.name + " (cloned)"
    new_swarm.save
    redirect_to new_swarm
  end

  private

  def scope_to_swarm
    @swarm = Swarm.find(params[:id])
  end

  def swarm_params
    params.require(:swarm).permit(:name, :description)
  end
end
