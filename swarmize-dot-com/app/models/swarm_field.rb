class SwarmField < ActiveRecord::Base
  belongs_to :swarm
  
  serialize :possible_values

  before_save :set_code

  private

  def set_code
    self.field_code = field_name.parameterize.underscore
  end
end
