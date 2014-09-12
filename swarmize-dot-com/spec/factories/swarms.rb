FactoryGirl.define do
  factory :swarm do |s|
    s.name "A test swarm"
    s.description "Test swarm description"
    s.token "abcdefgh"

    factory :swarm_opens_in_the_future do
      opens_at Time.zone.now + 1.day
    end

    factory :swarm_already_opened do
      opens_at Time.zone.now - 1.day
    end
  end
end
