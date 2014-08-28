FactoryGirl.define do
  factory :access_permission do
    user
    swarm
    email { user.email }
    is_owner false
    creator_id nil
  end
end
