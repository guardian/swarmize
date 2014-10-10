class Graph < ActiveRecord::Base
  belongs_to :swarm

  serialize :options
  GRAPH_TYPES = {pie: "Pie",
                 timeseries: "Time Series"}
                 
  def data_url(field, opts={})
    case viz_type
    when 'pie'
      count_url(field,opts)
    when 'timeseries'
      time_series_url(field,opts)
    end
  end

  private

  def count_url(graph_field, opts={})
    if opts[:filter_field]
      "/swarms/#{swarm.token}/graphs/count/#{graph_field}/#{opts[:filter_field]}"
    else
      "/swarms/#{swarm.token}/graphs/count/#{graph_field}"
    end
  end

  def time_series_url(graph_field, opts={})
    opens_at = swarm.opens_at || Time.now
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
