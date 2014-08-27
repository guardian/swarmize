class AccessPermission < ActiveRecord::Base
  belongs_to :swarm
  belongs_to :user

end

