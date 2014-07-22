class Swarm < ActiveRecord::Base
  serialize :fields

  def as_json(options={})
    {:name => self.name,
     :description => self.description,
     :fields => self.fields,
     :opens_at => self.opens_at,
     :closes_at => self.closes_at
    }
  end

  def swarm_key
    'voting' # TODO obviously not hardcoded
  end

  def search
    SwarmizeSearch.new(swarm_key)
  end

  def ready?
    opens_at || closes_at
  end

  def opens_now?
    opens_at.nil?
  end

  def closes_manually?
    closes_at.nil?
  end

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
