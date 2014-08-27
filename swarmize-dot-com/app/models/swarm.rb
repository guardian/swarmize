class TimeParadoxError < StandardError; end

class Swarm < ActiveRecord::Base
  include PgSearch

  belongs_to :creator, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :parent_swarm, :class_name => 'Swarm', :foreign_key => 'cloned_from'

  has_many :swarm_fields, -> { order('field_index ASC') }, :dependent => :destroy
  has_many :graphs
  has_many :clones, :class_name => 'Swarm', :foreign_key => 'cloned_from'

  has_many :access_permissions
  has_many :users, :through => :access_permissions
  has_many :creators, -> { where('access_permissions.is_creator' => true) }, :through => :access_permissions, :source => :user

  before_create :setup_token

  before_update :confirm_open_time
  before_update :confirm_close_time

  after_save :dynamo_sync
  after_destroy :dynamo_delete

  scope :latest, lambda {|n|
    limit(n)
  }

  scope :spiked, lambda { where(:is_spiked => true) }
  scope :unspiked, lambda { where(:is_spiked => false) }

  scope :yet_to_launch, lambda {
    where("opens_at IS NULL OR opens_at > ?", Time.zone.now).order("created_at DESC")
  }

  scope :closed, lambda {
    where("closes_at < ?", Time.zone.now).order("closes_at DESC")
  }

  scope :live, lambda {
    where("opens_at <= ?", Time.zone.now).where("closes_at IS NULL or closes_at > ?", Time.zone.now).order('opens_at DESC')
  }

  pg_search_scope :search_by_name_and_description, :against => {
    :name => 'A', 
    :description => 'B'
  }

  def to_param
    token
  end

  def spike!
    self.closes_at = Time.zone.now
    self.is_spiked = true
    self.save
  end

  def as_json(options={})
    {:name => self.name,
     :description => self.description,
     :fields => self.swarm_fields,
     :opens_at => self.opens_at,
     :closes_at => self.closes_at
    }
  end

  def collector_url
    "http://collector.swarmize.com/swarms/#{token}"
  end

  def search
    SwarmizeSearch.new(token)
  end

  def clone_by(user)
    new_swarm = self.dup
    new_swarm.opens_at = nil
    new_swarm.closes_at = nil
    new_swarm.parent_swarm = self
    new_swarm.creator = user
    new_swarm.name = self.name + " (cloned)"

    new_swarm.save

    self.swarm_fields.each do |f|
      new_f = f.dup
      new_f.swarm = new_swarm
      new_f.save
    end

    new_swarm
  end

  def has_opened?
    opens_at && (opens_at <= Time.zone.now)
  end

  def scheduled_to_open?
    opens_at && (opens_at > Time.zone.now)
  end

  def live?
    if has_opened?
      if closes_at
        closes_at > Time.zone.now
      else
        true
      end
    elsif opens_at
      opens_at <= Time.zone.now
    end
  end

  def closed?
    closes_at && (closes_at <= Time.zone.now)
  end

  def scheduled_to_close?
    closes_at && (closes_at > Time.zone.now)
  end

  def can_be_edited_by?(u)
    self.users.include?(u) || self.access_permissions.find_by(email: u.email)
  end

  def can_be_spiked_by?(u)
    self.creators.include? u
  end

  def regenerate_token!
    # this is really dangerous
    setup_token
    save
  end

  private

  def confirm_open_time
    if self.opens_at && self.opens_at_changed?
      if self.opens_at < Time.zone.now
        self.opens_at = Time.zone.now
      end

      if self.closes_at && (self.opens_at > self.closes_at)
        raise TimeParadoxError, "Swarm cannot close before it has opened!"
      end
    end
  end

  def confirm_close_time
    if self.closes_at && self.closes_at_changed?
      if self.closes_at < Time.zone.now
        self.closes_at = Time.zone.now
      end

      if self.opens_at && (self.closes_at < self.opens_at)
        raise TimeParadoxError, "Swarm cannot close before it has opened!"
      end
    end
  end

  def setup_token
    t = generate_token
    until !Swarm.find_by_token(t)
      t = generate_token
    end

    self.token = t
  end

  def generate_token(len=8)
    (0...len).map { (65 + rand(26)).chr.downcase }.join
  end

  def dynamo_sync
    DynamoSync.sync(self)
  end

  def dynamo_delete
    DynamoSync.delete(self)
  end

end
