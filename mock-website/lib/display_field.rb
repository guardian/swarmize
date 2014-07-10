class DisplayField
  attr_reader :name, :display_name, :formatter

  def initialize(name, display_name, formatter=nil)
    @name = name
    @display_name = display_name
    @formatter = formatter
  end

  def self.from_array(display_field_data)
    display_field_data.map do |f|
      self.new(f[0],f[1],f[2])
    end
  end
end
