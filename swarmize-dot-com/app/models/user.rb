class User < ActiveRecord::Base
  has_many :swarms

  def self.find_or_create_from_info_hash(info_hash)
    self.find_or_create_by(
      :email => info_hash['email'],
      :name => info_hash['name'],
      :image_url => info_hash['image']
    )
  end

  def self.is_valid_email?(email)
    (email == 'tom@infovore.org') || (email =~ /@theguardian\.com$/) || (email =~ /@guardian\.co\.uk$/)

  end
end
