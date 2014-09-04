class AccessPermission < ActiveRecord::Base
  belongs_to :swarm
  belongs_to :user
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'

  before_save :downcase_email

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

  def self.can_alter?(swarm, user)
    if user
      user.is_admin? || swarm.users.include?(user) || swarm.access_permissions.find_by(email: user.email)
    end
  end

  def self.can_destroy?(swarm,user)
    if user
      user.is_admin? || swarm.owners.include?(user)
    end
  end

  def self.can_alter_permissions?(swarm,user)
    if user
      user.is_admin? || swarm.owners.include?(user)
    end
  end

  def self.can_see_user_drafts?(current_user, user)
    current_user && ((current_user == user) || current_user.is_admin?)
  end
  private

  def downcase_email
    self.email = self.email.downcase
  end

end

