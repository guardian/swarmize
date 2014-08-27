require 'hashie'

class FieldDescription

  ALL_FIELDS = {    
    :text => {
      :display_name => "Text",
      :has_sample => true,
    },
    :bigtext => {
     :display_name => "Big Text",
     :has_sample => true,
     :has_custom_display_template => true
    },
    :address => {
     :display_name => "Address",
     :has_sample => true,
     :redact => true
    },
    :city => {
     :display_name => "City",
     :has_sample => true,
    },
    :county => {
     :display_name => "County",
     :has_sample => true,
    },
    :state => {
     :display_name => "State",
     :has_sample => true,
    },
    :country => {
     :display_name => "Country",
     :has_sample => true,
    },
    :postcode => {
     :display_name => "Postcode",
     :has_sample => true,
     :validation => "isAPostcode",
     :derived_fields => ["_lonlat"],
     :redact => true
    },
    :email => {
     :display_name => "Email",
     :has_sample => true,
     :input_type => 'email',
     :validation => 'email',
     :redact => true
    },
    :url => {
     :display_name => "URL",
     :has_sample => true,
     :validation => 'url'
    },
    :number => {
     :display_name => "Number",
     :has_sample => true,
     :validation => 'decimal'
    },
    :pick_one => {
     :display_name => "Pick One",
     :has_possible_values => true,
     :has_custom_display_template => true
    },
    :pick_several => {
     :display_name => "Pick Several",
     :has_possible_values => true,
     :has_custom_display_template => true
    },
    :rating => {
     :display_name => "Rating",
     :has_custom_display_template => true,
     :has_minimum => true,
     :has_maximum => true,
    },
    :yesno => {
     :display_name => "Yes/No",
     :has_custom_display_template => true
    },
    :check_box => {
     :display_name => "Checkbox",
     :has_custom_display_template => true,
     :validation => 'agreement'
    }
  }

  def self.all
    Hashie::Mash.new(ALL_FIELDS)
  end

  def self.has_custom_display?(type)
    ALL_FIELDS[type.to_sym][:has_custom_display_template]
  end

  def self.find(field_type)
    Hashie::Mash.new(ALL_FIELDS[field_type.to_sym])
  end

end
