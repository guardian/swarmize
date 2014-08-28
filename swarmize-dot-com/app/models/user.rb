class User < ActiveRecord::Base
  has_many :access_permissions
  has_many :swarms, :through => :access_permissions

  before_save :downcase_email
  after_create :update_access_permissions

  def self.find_or_create_from_info_hash(info_hash)
    self.find_or_create_by(
      :email => info_hash['email'],
      :name => info_hash['name'],
      :image_url => info_hash['image']
    )
  end

  def self.is_valid_email?(email)
    email = email.downcase
    (email == 'tom@infovore.org') || (email =~ /@theguardian\.com$/) || (email =~ /@guardian\.co\.uk$/)
  end

  private

  def downcase_email
    self.email = self.email.downcase
  end

  def update_access_permissions
    AccessPermission.update_legacy_permissions_for(self)
  end
end
