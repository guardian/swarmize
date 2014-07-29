class Swarm < ActiveRecord::Base
  belongs_to :user

  include LegacySwarm
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

  def has_opened?
    opens_at && (opens_at <= Time.now.utc)
  end

  def scheduled_to_open?
    opens_at && (opens_at > Time.now.utc)
  end

  def live?
    if has_opened?
      if closes_at
        closes_at > Time.now.utc
      else
        true
      end
    elsif opens_at
      opens_at <= Time.now.utc
    end
  end

  def can_be_edited?
    !has_opened?
  end

  def closed?
    closes_at && (closes_at <= Time.now.utc)
  end

  def scheduled_to_close?
    closes_at && (closes_at > Time.now.utc)
  end

end
