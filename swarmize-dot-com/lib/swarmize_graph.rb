class SwarmizeGraph
  attr_reader :title, :graph_type, :graph_field, :viz_type, :filter_field

  def initialize(title, graph_type, viz_type, graph_field, filter_field)
    @title = title
    @graph_type = graph_type
    @graph_field = graph_field
    @viz_type = viz_type
    @filter_field = filter_field
  end

  def self.from_array(graph_data)
    graph_data.map do |graph_hash|
      SwarmizeGraph.new(graph_hash[:title], graph_hash[:graph_type], graph_hash[:viz_type], graph_hash[:graph_field], graph_hash[:filter_field])
    end
  end

  def url_fragment
    case graph_type
    when 'count'
      "/graphs/count/#{graph_field}"
    when 'cardinal_count'
      "/graphs/count/#{graph_field}/#{filter_field}"
    end
  end

end
