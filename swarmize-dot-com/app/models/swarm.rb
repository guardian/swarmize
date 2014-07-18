class Swarm < ActiveRecord::Base
  serialize :fields

  def as_json(options={})
    {:name => self.name,
     :description => self.description,
     :fields => self.fields
    }
  end
end
