class DisplayField
  attr_reader :name, :field_type, :index, :compulsory, :sample, :possible_values, :custom_fields

  ALL = { :text => "Text",
          :bigtext => "Big Text",
          :address => "Address",
          :city => "City",
          :county => "County",
          :state => "State",
          :country => "Country",
          :postcode => "Postcode",
          :email => "Email",
          :number => "Number",
          :pick_one => "Pick One",
          :pick_several => "Pick Several",
          :rating => "Rating",
          :yesno => "Yes/No",
          :checkbox => "Checkbox"
  }

  def initialize(core,options={},custom_fields={})
    @name = core[:name]
    @field_type = core[:field_type]
    @index = core[:index]
    @compulsory = core[:compulsory]
    @sample = options[:sample]
    @possible_values = options[:possible_values]
    @custom_fields = custom_fields
  end

  def display_name
    ALL[field_type.to_sym]
  end

  def self.initialize_from_hash(hash)
    custom_fields = custom_fields_for_hash(hash)

    new({:name => hash['field_name'],
         :field_type => hash['field_type'],
         :index => hash['index'],
         :compulsory => hash['compulsory']
        },
        {:sample_value => hash['sample_value'],
         :possible_values => hash['possible_values']
        },
        custom_fields
       )

  end

  def self.from_array(array)
    array.map {|field| initialize_from_hash(field) }
  end

  def self.all

  end

  private

  def self.custom_fields_for_hash(hash)
    custom_field_keys = hash.keys - core_and_options
    custom_fields = {}

    custom_field_keys.each do |key|
      custom_fields[key.to_sym] = hash[key]
    end
    custom_fields
  end

  def self.core_and_options
    %w{field_name field_type index compulsory sample_value possible_values}
  end
end
