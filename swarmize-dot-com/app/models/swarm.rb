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

end
