require 'spec_helper'

RSpec.describe Swarm do
  describe "being asked if it can be edited by a user" do
    let(:swarm) { Swarm.create(:user_id => 1) }
    let(:this_user) { double('user1', :id => 1) }
    let(:another_user) { double('user2', :id => 2) }

    it "will return a truthy response if it is asked by the user who owns it and it has not opened" do

      expect(swarm.can_be_edited_by?(this_user)).to be_truthy
    end
    it "will return a falsey response if it is asked by the user who owns it and it has opened" do
      allow(swarm).to receive(:has_opened?).and_return(true)
      expect(swarm.can_be_edited_by?(this_user)).to be_falsey
    end
    it "will return a falsey response if it is asked by another user" do
      expect(swarm.can_be_edited_by?(another_user)).to be_falsey
    end
  end

  describe "being asked if it can be spiked by a user" do
    let(:swarm) { Swarm.create(:user_id => 1) }
    let(:this_user) { double('user1', :id => 1) }
    let(:another_user) { double('user2', :id => 2) }

    it "will return a truthy response if it is asked by the user who owns it" do
      expect(swarm.can_be_spiked_by?(this_user)).to be_truthy
    end

    it "will return a falsey response if it is asked by another user" do
      expect(swarm.can_be_spiked_by?(another_user)).to be_falsey
    end
  end
end
