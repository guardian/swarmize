require 'spec_helper'

describe AccessPermission do
  it "has a valid factory" do
    expect(Factory.create(:access_permission)).to be_valid 
  end

  it "is invalid if an AccessPermission for that swarm and email already exists" do
    user = Factory.build(:user)
    swarm = Factory.build(:swarm)
    Factory.create(:access_permission, :user => user, :swarm => swarm, :email => user.email)

    expect(Factory.build(:access_permission, :user => user, :swarm => swarm, :email => user.email)).to_not be_valid
  end

  it "is invalid if an AccessPermission for that swarm and user already exists" do
    email = Faker::Internet.email
    swarm = Factory.create(:swarm)
    Factory.create(:access_permission, :email => email, :swarm => swarm, :user => nil)

    expect(Factory.build(:access_permission, :email => email, :swarm => swarm, :user => nil)).to_not be_valid
  end
end
