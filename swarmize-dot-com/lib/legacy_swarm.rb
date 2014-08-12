module LegacySwarm
  # TODO: this is legacy from the mock application.
  def graphs
    graph_data = [
                  {:title => "Aggregate Feedback",
                   :graph_type => "count",
                   :graph_field => "feedback",
                   :viz_type => "pie"
                  },
                  {:title => "Aggregate Voting Intent",
                   :graph_type => "cardinal_count",
                   :viz_type => "pie",
                   :graph_field => "intent",
                   :filter_field => "user_key"
                  }
                 ]
     SwarmizeGraph.from_array(graph_data)
  end
end
