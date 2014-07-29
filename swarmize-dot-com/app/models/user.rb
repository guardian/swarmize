class User < ActiveRecord::Base
  has_many :swarms

  def self.first_or_create_from_info_hash(info_hash)
    self.first_or_create(
      :email => info_hash['email'],
      :name => info_hash['name'],
      :image_url => info_hash['image']
    )
  end

  def self.is_valid_email?(email)
    (email == 'tom@infovore.org') || (email =~ /@theguardian\.com$/)
  end
end
