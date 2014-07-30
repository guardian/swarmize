class Swarm < ActiveRecord::Base
  include LegacySwarm
  include PgSearch

  belongs_to :user
  belongs_to :parent_swarm, :class_name => 'Swarm', :foreign_key => 'cloned_from'

  before_update :confirm_open_time
  before_update :confirm_close_time

  pg_search_scope :search_by_name_and_description, :against => {
    :name => 'A', 
    :description => 'B'
  }

  scope :latest, lambda {|n|
    order("created_at DESC").limit(n)
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
    opens_at && (opens_at <= Time.now)
  end

  def scheduled_to_open?
    opens_at && (opens_at > Time.now)
  end

  def live?
    if has_opened?
      if closes_at
        closes_at > Time.now
      else
        true
      end
    elsif opens_at
      opens_at <= Time.now
    end
  end

  def closed?
    closes_at && (closes_at <= Time.now)
  end

  def scheduled_to_close?
    closes_at && (closes_at > Time.now)
  end


  def can_be_edited_by?(u)
    (self.user_id == u.id) && !has_opened?
  end

  def can_be_spiked_by?(u)
    self.user_id == u.id
  end

  private

  def confirm_open_time
    if self.opens_at
      if self.opens_at < Time.now
        self.opens_at = Time.now
      end

      if self.closes_at && (self.opens_at > self.closes_at)
        raise "Swarm cannot close before it has opened!"
      end
    end
  end

  def confirm_close_time
    if self.closes_at
      if self.closes_at < Time.now
        self.closes_at = Time.now
      end

      if self.opens_at && (self.closes_at > self.opens_at)
        raise "Swarm cannot close before it has opened!"
      end
    end
  end

end
