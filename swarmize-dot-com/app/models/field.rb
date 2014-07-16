require 'hashie'

class Field
  def self.from_hash(hash)
    Hashie::Mash.new(hash)
  end

  def self.null_field
    Hashie::Mash.new({})
  end
end
