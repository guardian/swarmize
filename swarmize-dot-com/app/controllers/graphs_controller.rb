class GraphsController < ApplicationController
  before_filter :scope_to_swarm
  before_filter :check_for_user, :only => %w{index new create edit update delete destroy}
  before_filter :check_user_has_permissions_on_swarm, only: %w{index new create edit update delete destroy}
  before_filter :scope_to_graph, only: %w{edit update delete destroy}

  def index
    @graphs = @swarm.graphs
  end

  def new
    @graph = @swarm.graphs.new
    setup_graphable_fields
  end

  def create
    graph = @swarm.graphs.new(graph_params)
    options = {}
    if !params[:filter_field].blank?
      options[:filter_field] = params[:filter_field]
    end
    graph.options = options
    graph.save
    redirect_to swarm_graphs_path(@swarm)
  end

  def edit
    setup_graphable_fields
  end

  def update
    @graph.update(graph_params)
    options = {}
    if !params[:filter_field].blank?
      options[:filter_field] = params[:filter_field]
    end
    @graph.options = options
    @graph.save
    redirect_to swarm_graphs_path(@swarm)
  end

  def delete
  end

  def destroy
    @graph.destroy
    flash[:success] = "Graph destroyed."
    redirect_to swarm_graphs_path(@swarm)
  end

  def aggregate_count
    results = {}
    @swarm.search.aggregate_count(params[:count_field]).each do |hash|
      results[hash.keys.first] = hash.values.first
    end
    
    render json: results
  end

  def cardinal_count
    results = {}
    @swarm.search.cardinal_count(params[:count_field], params[:unique_field]).each do |hash|
      results[hash.keys.first] = hash.values.first
    end

    render json: results
  end

  def count_over_time
    results = @swarm.search.count_over_time(params[:count_field], params[:interval]).map do |k| 
      field_name = k.keys.first
      data = k[field_name].map do |row|
        t = row.keys.first
        value = row[t]
        {x: t/1000, y: value} # elasticsearch stores in miliseconds
      end
      {name: field_name,
       data: data}
    end

    render json: results
  end

  private

  def scope_to_swarm
    @swarm = Swarm.find_by(token: params[:swarm_id])
    if @swarm && @swarm.draft?
      check_for_user
    end
  end

  def scope_to_graph
    @graph = @swarm.graphs.find(params[:id])
  end

  def check_user_has_permissions_on_swarm
    unless AccessPermission.can_alter?(@swarm, @current_user)
      flash[:error] = "You don't have permission to do that."
      redirect_to root_path
    end
  end

  def graph_params
    params.require(:graph).permit(:title, :graph_type, :field, :filter_field, :viz_type)
  end

  def setup_graphable_fields
    graphable_fields = @swarm.swarm_fields.where(field_type: SwarmField.graphable)
    if graphable_fields.any?
      @graphable_fields = graphable_fields.map do |f|
        [f.field_name, f.field_code]
      end
     @filter_fields = @swarm.swarm_fields.map do |f|
        [f.field_name, f.field_code]
      end
      @graph_types = Graph::GRAPH_TYPES.invert
    end
  end

end
