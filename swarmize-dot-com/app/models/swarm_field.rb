class SwarmField < ActiveRecord::Base
  belongs_to :swarm
  
  serialize :possible_values

  before_create :set_code 

  def as_json(options={})
    json_fields = {:field_type => self.field_type,
         :field_name => self.field_name,
         :field_name_code => self.field_code,
         :compulsory => self.compulsory}

    if field_type == 'rating'
      json_fields[:maximum] = self.maximum
      json_fields[:minimum] = self.minimum
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
    description[:derived_fields]
  end

  def derived_field_codes
    if description[:derived_fields]
      description[:derived_fields].map do |suffix|
        field_code + suffix
      end
    end
  end

  private

  def set_code
    self.field_code = field_name.parameterize.underscore
  end
end
