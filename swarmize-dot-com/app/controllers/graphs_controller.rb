class GraphsController < ApplicationController
  before_filter :scope_to_swarm
  before_filter :scope_to_graph, :only => %w{edit update delete destroy}

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
    results = @swarm.search.aggregate_count(params[:count_field]).map do |hash|
      { label: hash.keys.first,
        value: hash.values.first
      }
    end
    
    render :json => results
  end

  def cardinal_count
    results = @swarm.search.cardinal_count(params[:count_field], params[:unique_field]).map do |hash|
      {
        label: hash.keys.first,
        value: hash.values.first
      }
    end

    render :json => results
  end

  private

  def scope_to_swarm
    @swarm = Swarm.find_by(token: params[:swarm_id])
  end

  def scope_to_graph
    @graph = @swarm.graphs.find(params[:id])
  end

  def graph_params
    params.require(:graph).permit(:title, :graph_type, :field, :filter_field, :viz_type)
  end

  def setup_graphable_fields
    pick_one_fields = @swarm.swarm_fields.where(:field_type => 'pick_one')
    if pick_one_fields.any?
      @graphable_fields = pick_one_fields.map do |f|
        [f.field_name, f.field_code]
      end
      @filter_fields = @swarm.swarm_fields.map do |f|
        [f.field_name, f.field_code]
      end
      @graph_types = [['Pie', 'pie']]
    end
  end

end
