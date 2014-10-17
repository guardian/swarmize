class TimeParadoxError < StandardError; end

class Swarm < ActiveRecord::Base
  include PgSearch

  acts_as_paranoid

  belongs_to :parent_swarm, :class_name => 'Swarm', :foreign_key => 'cloned_from'

  has_many :swarm_fields, -> { order('field_index ASC') }, :dependent => :destroy
  has_many :graphs
  has_many :clones, :class_name => 'Swarm', :foreign_key => 'cloned_from'

  has_many :access_permissions
  has_many :unassigned_access_permissions, -> { where('user_id IS NULL') }, :class_name => 'AccessPermission'
  has_many :users, :through => :access_permissions
  has_many :owners, -> { where('access_permissions.is_owner' => true) }, :through => :access_permissions, :source => :user

  before_create :setup_token

  before_update :confirm_open_time
  before_update :confirm_close_time

  after_save :dynamo_sync
  after_destroy :dynamo_delete

  scope :latest, lambda {|n|
    limit(n)
  }

  scope :publicly_visible, lambda {
    where("(closes_at < ?) OR (opens_at <= ? AND (closes_at IS NULL or closes_at > ?))", Time.zone.now, Time.zone.now, Time.zone.now).order("opens_at DESC")
  }

  scope :draft, lambda {
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

  def creator
    owners.order(:created_at).first
  end
  
  def to_param
    token
  end

  def spike!
    self.closes_at = Time.zone.now
    self.destroy
  end

  def as_json(options={})
    {:name => self.name,
     :description => self.description,
     :fields => self.swarm_fields,
     :opens_at => self.opens_at,
     :closes_at => self.closes_at,
     :token => self.token,
     :display_title => self.display_title,
     :display_description => self.display_description
    }
  end

  def collector_url
    "http://collector.swarmize.com/swarms/#{token}"
  end

  def search
    if draft?
      SwarmizeSearch.new("#{token}_draft")
    else
      SwarmizeSearch.new(token)
    end
  end

  def clone_by(user)
    new_swarm = self.dup
    new_swarm.token = nil
    new_swarm.opens_at = nil
    new_swarm.closes_at = nil
    new_swarm.parent_swarm = self
    #new_swarm.creator = user
    new_swarm.name = self.name + " (cloned)"

    new_swarm.save

    AccessPermission.create(:swarm => new_swarm,
                            :user => user,
                            :email => user.email,
                            :is_owner => true)

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

  def draft?
    opens_at.nil? || (opens_at > Time.zone.now)
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
    AccessPermission.can_edit? self, u
  end

  def regenerate_token!
    # this is really dangerous
    setup_token
    save
  end

  def field_codes
    output = %w{timestamp}
    swarm_fields.each do |f|
      output << f.field_code
      output << f.derived_field_codes if f.derived_field_codes
    end
    output.flatten
  end

  def public_field_codes
    output = %w{timestamp}
    swarm_fields.each do |f|
      unless f.redacted?
        output << f.field_code
        output << f.derived_field_codes if f.derived_field_codes
      end
    end
    output.flatten
  end

  def api_keys
    keys = []
    APIKey.all.where(:swarm_token => self.token).select do |item_data|
        keys << item_data.attributes #=> { 'id' => 'abc', 'category' => 'foo', ... }
    end

    keys.each do |t|
      t['created_by'] = User.find_by(email: t['created_by'])
    end

    keys
  end

  def estimate_form_height
    height = 210

    if swarm_fields.any?
      fields_height = swarm_fields.map do |field|
        case field.field_type
        when 'pick_one', 'pick_several'
          field_height = 30

          if field.possible_values.any?
            field_height = field_height + (30 * field.possible_values.size)
          end

          field_height
        when 'bigtext'
          220
        else
          80
        end
      end.sum 

      height = height + fields_height
    end

    height
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
    unless self.token
      t = generate_token
      until !Swarm.find_by_token(t)
        t = generate_token
      end

      self.token = t
    end
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
