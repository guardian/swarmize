class SwarmizeGraph
  def self.count_url(swarm, graph_field, filter_field=nil)
    if filter_field
      "/swarms/#{swarm.token}/graphs/count/#{graph_field}/#{filter_field}"
    else
      "/swarms/#{swarm.token}/graphs/count/#{graph_field}"
    end
  end

  def self.time_series_url(swarm, graph_field)
    opens_at = swarm.opens_at
    closes_at = swarm.closes_at || Time.now
    interval = 'hour'
    case (closes_at - opens_at)
    when (1.hour..1.day)
      interval = 'minute'
    when (0..1.hour)
      interval = 'minute'
    end

    "/swarms/#{swarm.token}/graphs/count_over_time/#{graph_field}/#{interval}"
  end
end
