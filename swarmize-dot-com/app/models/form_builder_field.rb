require 'hashie'

class FormBuilderField

  ALL_FIELDS = [
    {:field_type => "text",
     :display_name => "Text",
     :has_sample => true,
     :has_possible_values => false
    },
    {:field_type => "bigtext",
     :display_name => "Big Text",
     :has_sample => true,
     :has_possible_values => false,
     :input_type => 'textarea'
    },
    {:field_type => "address",
     :display_name => "Address",
     :has_sample => true,
     :has_possible_values => false,
    },
    {:field_type => "city",
     :display_name => "City",
     :has_sample => true,
     :has_possible_values => false
    },
    {:field_type => "county",
     :display_name => "County",
     :has_sample => true,
     :has_possible_values => false
    },
    {:field_type => "state",
     :display_name => "State",
     :has_sample => true,
     :has_possible_values => false
    },
    {:field_type => "country",
     :display_name => "Country",
     :has_sample => true,
     :has_possible_values => false
    },
    {:field_type => "postcode",
     :display_name => "Postcode",
     :has_sample => true,
     :has_possible_values => false
    },
    {:field_type => "email",
     :display_name => "Email",
     :has_sample => true,
     :has_possible_values => false,
     :input_type => 'email'
    },
    {:field_type => "number",
     :display_name => "Number",
     :has_sample => true,
     :has_possible_values => false,
     :input_type => 'number'
    },
    {:field_type => "pick_one",
     :display_name => "Pick One",
     :has_sample => false,
     :has_possible_values => true
    },
    {:field_type => "pick_several",
     :display_name => "Pick Several",
     :has_sample => false,
     :has_possible_values => true
    },
    {:field_type => "rating",
     :display_name => "Rating",
     :has_sample => false,
     :has_possible_values => false,
     :custom_fields => [ 
                        {:display_name => 'Minimum',
                         :field_type => 'minimum',
                         :input_type => 'number'},
                        {:display_name => "Maximum",
                         :field_type => 'maximum',
                         :input_type => 'number'}
                       ]
    },
    {:field_type => "yesno",
     :display_name => "Yes/No",
     :has_sample => false,
     :has_possible_values => false
    },
    {:field_type => "check_box",
     :display_name => "Checkbox",
     :has_sample => false,
     :has_possible_values => false
    }
  ]

  def self.all
    ALL_FIELDS.map {|f| Hashie::Mash.new(f)}
  end

  def self.find(field_type)
    self.all.find {|f| f.field_type == field_type}
  end

end
