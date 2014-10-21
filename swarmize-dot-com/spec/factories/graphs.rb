FactoryGirl.define do
  factory :graph do 
    title "Graph Title"
    graph_type "pie"
    field "postcode"
    swarm
  end
end
