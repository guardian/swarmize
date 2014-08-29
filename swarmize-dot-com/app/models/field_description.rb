require 'hashie'

class FieldDescription

  ALL_FIELDS = JSON.parse(File.read(Rails.root.join('field_types.json')))

  def self.all
    Hashie::Mash.new(ALL_FIELDS)
  end

  def self.find(field_type)
    all.send(field_type)
  end

end
