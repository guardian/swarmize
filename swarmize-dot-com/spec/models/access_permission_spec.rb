require 'spec_helper'

describe AccessPermission do
  it "has a valid factory" do
    expect(Factory.create(:access_permission)).to be_valid 
  end

  it "is invalid if an AccessPermission for that swarm and email already exists" do
    user = Factory.create(:user)
    swarm = Factory.create(:swarm)
    AccessPermission.create(:user => user, :swarm => swarm, :email => user.email)

    expect(AccessPermission.new(:user => user, :swarm => swarm, :email => user.email)).to_not be_valid
  end

  it "is invalid if an AccessPermission for that swarm and user already exists" do
    email = Faker::Internet.email
    swarm = Factory.create(:swarm)
    AccessPermission.create(:swarm => swarm, :email => email)

    expect(AccessPermission.new(:swarm => swarm, :email => email)).to_not be_valid
  end
end
