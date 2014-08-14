class Graph < ActiveRecord::Base
  belongs_to :swarm

  serialize :options
end
