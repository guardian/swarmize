FactoryGirl.define do
  factory :graph do 
    title "Graph Title"
    graph_type "count"
    field "postcode"
    viz_type "pie"
    swarm
  end
end
