class SwarmField < ActiveRecord::Base
  belongs_to :swarm
  
  serialize :possible_values

  before_save :set_code # TODO: this should probably be before_create
                        # so that people can edit things

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

  private

  def set_code
    self.field_code = field_name.parameterize.underscore
  end
end
