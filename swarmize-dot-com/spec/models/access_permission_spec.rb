require 'spec_helper'

describe AccessPermission do
  it "has a valid factory" do
    expect(Factory.create(:access_permission)).to be_valid 
  end

  describe "being saved" do
    it "should ensure its email is stored downcase" do
      ap = Factory.build(:access_permission, :email => 'BOB@TEST.com')
      ap.save
      expect(ap.email).to eq('bob@test.com')
    end
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

  describe "updating legacy permissions" do
    it "should set any access permissions assigned to an email address to a user with that email address" do
      user = Factory.create(:user, :email => "test@test.com")
      ap = Factory.create(:access_permission, :email => "test@test.com", :user => nil)

      AccessPermission.update_legacy_permissions_for(user)
      ap.reload
      expect(ap.user).to eq(user)
    end
  end
end
