class SwarmsController < ApplicationController
  before_filter :scope_to_swarm, :except => %w{index yet_to_open live closed new create mine}
  before_filter :check_for_user, :except => %w{index yet_to_open live closed show embed}
  before_filter :count_swarms, :only => %w{index yet_to_open live closed}

  respond_to :html, :json

  def index
    @swarms = Swarm.unspiked.paginate(:page => params[:page])
  end

  def yet_to_open
    @swarms = Swarm.unspiked.yet_to_launch.paginate(:page => params[:page])
  end

  def live
    @swarms = Swarm.unspiked.live.paginate(:page => params[:page])
  end
  
  def closed
    @swarms = Swarm.unspiked.closed.paginate(:page => params[:page])
  end

  def mine
    redirect_to user_path(@current_user)
  end

  def show
    if params[:page]
      @current_page = params[:page].to_i
    else
      @current_page = 1
    end

    if @swarm.closed? || @current_user
      begin
        @rows, @total_pages = @swarm.search.all(@current_page, 10)
      rescue Faraday::TimeoutError, Faraday::ConnectionFailed
        @rows, @total_pages = [], 0
        @elasticsearch_error = "There was an error connecting to Elasticsearch, and results cannot be shown."
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        @rows, @total_pages = [], 0
        @elasticsearch_error = "There are no results in Elasticsearch yet."
      end
    end
    respond_with @swarm
  end

  def csv
    results = @swarm.search.entirety
    formatted_results = SwarmResultsFormatter.new(@swarm,results)
    send_data formatted_results.to_csv, 
              filename: "#{@swarm.token}.csv"
  end

  def delete
  end

  def destroy
    @swarm.destroy
    redirect_to swarms_path
  end

  def spike
  end

  def do_spike
    @swarm.spike!
    flash[:success] = "'#{@swarm.name}' was spiked, and is no longer visible."
    redirect_to swarms_path
  end

  def new
    @swarm = Swarm.new
  end

  def fields
  end

  def update_fields
    if @swarm.has_opened?
      params[:fields].each do |f|
        if f[:id]
          field = @swarm.swarm_fields.find(f[:id])
          field.update(f)
        end
      end
    else
      @swarm.swarm_fields.destroy_all

      params[:fields].each do |f|
        f['id'] = nil # unset any previously set id
        @swarm.swarm_fields.create(f)
      end
    end

    # has to be called manually, because swarm_fields now a model.
    DynamoSync.sync(@swarm)
    
    if params[:update_and_next]
      redirect_to preview_swarm_path(@swarm)
    else
      redirect_to edit_swarm_path(@swarm)
    end
  end

  def preview
  end

  def embed
    render layout: 'embed'
  end

  def create
    swarm = Swarm.new(swarm_params)
    swarm.creator = @current_user
    swarm.save
    redirect_to fields_swarm_path(swarm)
  end

  def edit
  end

  def update
    @swarm.update(swarm_params)
    redirect_to fields_swarm_path(@swarm)
  end

  def open
    open_time = Time.zone.local(params['open_year'],
                                params['open_month'],
                                params['open_day'],
                                params['open_hour'],
                                params['open_minute'])
    @swarm.update(:opens_at => open_time)
    redirect_to @swarm
  end

  def close
    close_time = Time.zone.local(params['close_year'],
                                 params['close_month'],
                                 params['close_day'],
                                 params['close_hour'],
                                 params['close_minute'])

    begin
      @swarm.update(:closes_at => close_time)
    rescue TimeParadoxError
      flash[:error] = "Swarm cannot close before it has opened!"
    end
    redirect_to @swarm
  end

  def clone
    new_swarm = @swarm.clone_by(@current_user)
    redirect_to new_swarm
  end

  private

  def scope_to_swarm
    @swarm = Swarm.unspiked.find_by(token: params[:id])
  end

  def swarm_params
    params.require(:swarm).permit(:name, :description)
  end

  def count_swarms
    @all_swarms_count = Swarm.unspiked.count
    @open_swarms_count = Swarm.unspiked.yet_to_launch.count
    @live_swarms_count= Swarm.unspiked.live.count
    @closed_swarms_count = Swarm.unspiked.closed.count
  end
end
