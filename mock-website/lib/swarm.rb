class Swarm
  attr_reader :key, :name, :search, :display_fields, :graphs

  def initialize(key,name, display_field_data, graph_data)
    @key = key
    @name = name
    @search = SwarmizeSearch.new(key)
    @display_fields = DisplayField.from_array(display_field_data)
    @graphs = Graph.from_array(graph_data)
  end

end
