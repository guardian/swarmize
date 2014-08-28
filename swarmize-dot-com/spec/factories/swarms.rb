FactoryGirl.define do
  factory :swarm do |s|
    s.name "A test swarm"
    s.description "Test swarm description"
    s.is_spiked nil
    s.token "abcdefgh"
  end
end
