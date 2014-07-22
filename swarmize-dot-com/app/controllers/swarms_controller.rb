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

  def commission
  end

  def do_commission
    if params[:swarm_ready] == 'false'
      @swarm.opens_at = nil
      @swarm.closes_at = nil
    else
      if params['swarm_opens_now'] == 'true'
        @swarm.opens_at = Time.now
      else
        open_time = Time.new(params['open_year'],
                             params['open_month'],
                             params['open_day'],
                             params['open_hour'],
                             params['open_minute'])
        @swarm.opens_at = open_time
      end

      if params['swarm_closes_manually'] == 'true'
        @swarm.closes_at = nil
      else
        close_time = Time.new(params['close_year'],
                              params['close_month'],
                              params['close_day'],
                              params['close_hour'],
                              params['close_minute'])
        @swarm.closes_at = close_time
      end
    end
    @swarm.save
    redirect_to swarms_path
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
