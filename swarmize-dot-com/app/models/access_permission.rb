class AccessPermission < ActiveRecord::Base
  belongs_to :swarm
  belongs_to :creator, :class_name => 'User', :foreign_key => 'user_id'

  def user
    User.where(email: email).first
  end
end

