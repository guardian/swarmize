class SwarmizeGraph
  def self.count_url(swarm, graph_field, filter_field=nil)
    if filter_field
      "/swarms/#{swarm.token}/graphs/count/#{graph_field}/#{filter_field}"
    else
      "/swarms/#{swarm.token}/graphs/count/#{graph_field}"
    end
  end

  def self.time_series_url(swarm, graph_field)
    # TODO: scale interval, please
    interval = 'minute'
    "/swarms/#{swarm.token}/graphs/count_over_time/#{graph_field}/#{interval}"
  end
end
