class SwarmizeGraph
  def self.count_url(swarm, graph_field, filter_field=nil)
    if filter_field
      "/swarms/#{swarm.token}/graphs/count/#{graph_field}/#{filter_field}"
    else
      "/swarms/#{swarm.token}/graphs/count/#{graph_field}"
    end
  end
end
