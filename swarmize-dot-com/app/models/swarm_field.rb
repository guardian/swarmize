class SwarmField < ActiveRecord::Base
  belongs_to :swarm
  
  serialize :possible_values

  before_create :set_code 

  def as_json(options={})
    json_fields = {:field_type => self.field_type,
         :field_name => self.field_name,
         :field_name_code => self.field_code,
         :compulsory => self.compulsory}

    if description.has_maximum && self.maximum
      json_fields[:maximum] = self.maximum
    end

    if description.has_minimum && self.minimum
      json_fields[:minimum] = self.minimum 
    end

    if description.has_other_field && self.allow_other
      json_fields[:allow_other] = self.allow_other 
    end

    if possible_values && possible_values.any?
      json_fields[:possible_values] = possible_values.inject({}) {|hash, p|
        hash.merge({p.parameterize.underscore => p})
      }
    end

    json_fields
  end

  def description
    FieldDescription.find(field_type)
  end

  def derived_field_suffixes
    if description.process 
      # You could do something clever with a map...
      # ...but one process might have many derives
      # ...so let's do something simple
      suffixes = []
      description.process.each do |prc|
        prc.derives.each do |suffix,archetype|
          suffixes << suffix
        end
      end
      suffixes
    end
  end

  def derived_field_codes
    if derived_field_suffixes
      derived_field_suffixes.map do |suffix|
        field_code + suffix
      end
    end
  end

  def redacted?
    description.redact
  end

  def has_custom_display?
    description.has_custom_display_template
  end

  def has_custom_field_code?
    if !field_code.blank? && !field_name.blank?
      self.field_code != SwarmField.encode_field_name(field_name)
    end
  end

  def self.encode_field_name(name)
    name.to_s.strip.parameterize.underscore
  end

  def self.graphable
    %w{pick_one pick_several yesno}
  end

  private

  def set_code
    if self.field_code.blank?
      self.field_code = SwarmField.encode_field_name(field_name)
    end
  end
end
