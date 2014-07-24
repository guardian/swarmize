module LegacySwarm
  # this class is all the stuff from the old Sinatra prototype.
  def display_fields
    display_field_data = [
                            ["timestamp", "Timestamp", 'timestamp'],
                            ["postcode", "Postcode"],
                            ["intent", "Intent"],
                            ["feedback", "Feedback"],
                            ["ip", "IP"],
                            ["user_key", "User Key"]
                          ]
    SwarmizeDisplayField.from_array(display_field_data)
  end

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
