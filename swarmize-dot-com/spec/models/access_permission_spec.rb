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

  describe "being asked if it can be altered by a user" do
    let(:swarm) { Factory.create(:swarm) }
    let(:this_user) { Factory.create(:user) }
    let(:another_user) { Factory.create(:user) }
    let(:permitted_user) { Factory.create(:user) }

    it "will return a truthy response if it is asked by the user who owns it" do
      Factory.create(:access_permission, 
                     :user => this_user,
                     :swarm => swarm,
                     :is_owner => true)
                                      
      expect(AccessPermission.can_alter?(swarm, this_user)).to be_truthy
    end

    it "will return a truthy response if it is asked by a user who has permission" do
      Factory.create(:access_permission, 
                     :user => permitted_user,
                     :swarm => swarm)

      expect(AccessPermission.can_alter?(swarm, this_user)).to be_truthy
    end

    it "will return a truthy response if it is asked by a user whose email has permission" do
      Factory.create(:access_permission, 
                     :user => nil,
                     :email => permitted_user.email,
                     :swarm => swarm)

      expect(AccessPermission.can_alter?(swarm, this_user)).to be_truthy
    end

    it "will return a truthy response if it is asked by a user who is an admin" do
      admin = Factory.create(:admin)
      expect(AccessPermission.can_alter?(swarm, admin)).to be_truthy
    end

    it "will return a falsey response if it is asked by another user who does now have permission" do
      expect(AccessPermission.can_alter?(swarm, this_user)).to be_falsey
    end
  end

  describe "checking if a user can destroy a swarm" do
    let(:swarm) { Factory.create(:swarm) }
    let(:this_user) { Factory.create(:user) }
    let(:another_user) { Factory.create(:user) }
    let(:permitted_user) { Factory.create(:user) }


    it "will return a truthy response if it is asked by the user who owns it" do
      Factory.create(:access_permission, 
                     :user => this_user,
                     :swarm => swarm,
                     :is_owner => true)
                                      
      expect(AccessPermission.can_destroy?(swarm, this_user)).to be_truthy
    end

    it "will return a truthy response if it is asked by a user who is an admin" do
      admin = Factory.create(:admin)
      expect(AccessPermission.can_destroy?(swarm, admin)).to be_truthy
    end


    it "will return a falsey response if it is asked by a user with permissions who is not the owner" do
      Factory.create(:access_permission, 
                     :user => permitted_user,
                     :swarm => swarm)
                                      
      expect(AccessPermission.can_destroy?(swarm, this_user)).to be_falsey
    end

    it "will return a falsey response if it is asked by another user who has no permissions" do
      expect(AccessPermission.can_destroy?(swarm, this_user)).to be_falsey
    end


  end
end

