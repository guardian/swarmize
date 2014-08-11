class TimeParadoxError < StandardError; end

class Swarm < ActiveRecord::Base
  include LegacySwarm
  include PgSearch

  belongs_to :user
  belongs_to :parent_swarm, :class_name => 'Swarm', :foreign_key => 'cloned_from'

  before_update :confirm_open_time
  before_update :confirm_close_time

  scope :latest, lambda {|n|
    limit(n)
  }

  scope :spiked, lambda { where(:is_spiked => true) }
  scope :unspiked, lambda { where(:is_spiked => false) }

  scope :yet_to_launch, lambda {
    where("opens_at IS NULL OR opens_at > ?", Time.now).order("created_at DESC")
  }

  scope :closed, lambda {
    where("closes_at < ?", Time.now).order("closes_at DESC")
  }

  scope :live, lambda {
    where("opens_at <= ?", Time.now).where("closes_at IS NULL or closes_at > ?", Time.now).order('opens_at DESC')
  }

  pg_search_scope :search_by_name_and_description, :against => {
    :name => 'A', 
    :description => 'B'
  }

  serialize :fields

  def spike!
    self.closes_at = Time.now
    self.is_spiked = true
    self.save
  end

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

  def clone_by(user)
    new_swarm = self.dup
    new_swarm.opens_at = nil
    new_swarm.closes_at = nil
    new_swarm.parent_swarm = self
    new_swarm.user = user
    new_swarm.name = self.name + " (cloned)"
    new_swarm
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
    if self.opens_at && self.opens_at_changed?
      if self.opens_at < Time.now
        self.opens_at = Time.now
      end

      if self.closes_at && (self.opens_at > self.closes_at)
        raise TimeParadoxError, "Swarm cannot close before it has opened!"
      end
    end
  end

  def confirm_close_time
    if self.closes_at && self.closes_at_changed?
      if self.closes_at < Time.now
        self.closes_at = Time.now
      end

      if self.opens_at && (self.closes_at < self.opens_at)
        raise TimeParadoxError, "Swarm cannot close before it has opened!"
      end
    end
  end

end
