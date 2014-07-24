class Swarm < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_by_name_and_description, :against => {
    :name => 'A', 
    :description => 'B'
  }

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

  def live?
    if closes_at && opens_at
      (Time.now.utc >= opens_at) && (Time.now.utc < closes_at)
    elsif opens_at
      Time.now.utc >= opens_at 
    end
  end

  def can_be_edited?
    opens_at.nil? || (opens_at > Time.now.utc)
  end

  def has_opened?
    !opens_at.nil? && (opens_at <= Time.now.utc)
  end

  def scheduled_to_open?
    !opens_at.nil? && (opens_at > Time.now.utc)
  end

  def closed?
    !closes_at.nil? && (closes_at <= Time.now.utc)
  end

  def scheduled_to_close?
    !closes_at.nil? && (closes_at > Time.now.utc)
  end

  def open!
    update_attribute(:opens_at, Time.now.utc)
  end

  def close!
    update_attribute(:closes_at, Time.now.utc)
  end


  # TODO: this is legacy from the mock application.
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
