FactoryGirl.define do
  factory :swarm_field do
    field_index 0
    field_type 'text'
    field_name 'Enter some text'
    hint 'Anything will do'
    sample_value 'foo'
    swarm
  end
end
