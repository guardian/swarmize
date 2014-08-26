class AccessPermission < ActiveRecord::Base
  belongs_to :swarm
  belongs_to :creator, :class_name => 'User', :foreign_key => 'user_id'

  validates_uniqueness_of :email

  def user
    User.where(email: email).first
  end
end
