class Swarm
  attr_reader :key, :name, :search, :display_fields

  def initialize(key,name, display_field_data)
    @key = key
    @name = name
    @search = SwarmizeSearch.new(key)
    @display_fields = DisplayField.from_array(display_field_data)
  end

end
