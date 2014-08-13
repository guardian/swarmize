require 'securerandom'

class TimeParadoxError < StandardError; end

class Swarm < ActiveRecord::Base
  include PgSearch

  belongs_to :user
  belongs_to :parent_swarm, :class_name => 'Swarm', :foreign_key => 'cloned_from'

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

  def to_param
    token
  end

  def spike!
    self.closes_at = Time.now
    self.is_spiked = true
    self.save
  end

  def as_json(options={})
    {:name => self.name,
     :description => self.description,
     :fields => self.fields_for_json,
     :opens_at => self.opens_at,
     :closes_at => self.closes_at
    }
  end

  def fields_for_json
    if fields
      fields.map do |f|
        json_fields = {}
        json_fields[:field_type] = f['field_type']
        json_fields[:field_name] = f['field_name']
        json_fields[:field_name_code] = f['field_name'].parameterize.underscore
        json_fields[:compulsory] = (f['compulsory'] == '1')
        json_fields[:minimum] = f['minimum'].to_i unless f['minimum'].blank?
        json_fields[:maximum] = f['maximum'].to_i unless f['maximum'].blank?

        
        if f['possible_values']
          json_fields[:possible_values] = f['possible_values'].inject({}) {|hash, p|
            hash.merge({p.parameterize.underscore => p})
          }
        end

        json_fields
      end
    end
  end

  def fields_of_type(t)
    fields.select {|f| f[:field_type] == t} if fields
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

  def regenerate_token!
    # this is really dangerous
    setup_token
    save
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
