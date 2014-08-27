class AccessPermission < ActiveRecord::Base
  belongs_to :swarm
  belongs_to :user
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'

  validates :email, uniqueness: { scope: :swarm,
    message: "can only be given permission on a swarm once" }
  validates :user, uniqueness: { scope: :swarm,
    message: "can only be given permission on a swarm once" }, if: :user
end

