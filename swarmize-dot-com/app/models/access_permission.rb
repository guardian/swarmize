class AccessPermission < ActiveRecord::Base
  belongs_to :swarm
  belongs_to :user
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'

  validates :email, uniqueness: { scope: :swarm,
    message: "can only be given permission on a swarm once" }
  validates :user, uniqueness: { scope: :swarm,
    message: "can only be given permission on a swarm once" }, if: :user

  def self.update_legacy_permissions_for(user)
    aps = AccessPermission.where(email: user.email)
    aps.each do |ap|
      ap.user = user
      ap.save
    end
  end
end

