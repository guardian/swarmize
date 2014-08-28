require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.name Faker::Name.name
    f.email Faker::Internet.email
    f.image_url ""
    f.is_fake false
    
    factory :admin do
      is_admin true
    end
  end
end
