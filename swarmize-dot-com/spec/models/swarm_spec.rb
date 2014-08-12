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

  describe "that will open in the future" do
    let(:swarm) { Swarm.create(:opens_at => (Time.now + 1.day) ) }

    it "should not describe itself as live" do
      expect(swarm.live?).to be_falsy
    end

    it "should not describe itself as having opened" do
      expect(swarm.has_opened?).to be_falsy
    end

    it "should not describe itself as closed" do
      expect(swarm.closed?).to be_falsy
    end

    it "should describe itself as scheduled to open" do
      expect(swarm.scheduled_to_open?).to be_truthy
    end

    describe "that has no close date" do
      it "should not describe itself as scheduled to close" do
        expect(swarm.scheduled_to_close?).to be_falsy
      end
    end

    describe "that has a close date" do
      let(:swarm) { Swarm.create(:opens_at => (Time.now + 1.day),
                                 :closes_at => (Time.now + 2.days)) }
      it "should a describe itself as scheduled to close" do
        expect(swarm.scheduled_to_close?).to be_truthy
      end
    end
  end

  describe "that has opened in the past" do
    let(:swarm) { Swarm.create(:opens_at => (Time.now - 1.day) ) }

    it "should describe itself as having opened" do
      expect(swarm.has_opened?).to be_truthy
    end

    it "should not describe itself as scheduled to open" do
      expect(swarm.scheduled_to_open?).to be_falsy
    end

    describe "and has no close date" do
      it "should describe itself as live" do
        expect(swarm.live?).to be_truthy
      end

      it "should not describe itself as scheduled to close" do
        expect(swarm.scheduled_to_close?).to be_falsy
      end

      it "should not describe itself as closed" do
        expect(swarm.closed?).to be_falsy
      end

    end

    describe "and that has closed in the past" do
      let(:swarm) { Swarm.create(:opens_at => (Time.now - 1.day),
                                 :closes_at => (Time.now - 1.hour) ) }

      it "should not describe itself as live" do
        expect(swarm.live?).to be_falsy
      end

      it "should not describe itself as scheduled to close" do
        expect(swarm.scheduled_to_close?).to be_falsy
      end

      it "should describe itself as closed" do
        expect(swarm.closed?).to be_truthy
      end
    end

    describe "and that closes in the future" do
      let(:swarm) { Swarm.create(:opens_at => (Time.now - 1.day),
                                 :closes_at => (Time.now + 1.day) ) }

      it "should describe itself as live" do
        expect(swarm.live?).to be_truthy
      end

      it "should describe itself as scheduled to close" do
        expect(swarm.scheduled_to_close?).to be_truthy
      end

      it "should not describe itself as closed" do
        expect(swarm.closed?).to be_falsy
      end
    end
  end

  describe "having its open date set" do
    let(:swarm) { Swarm.create() }
    it "should really be the time it was asked to be set to, if it's set to the future" do
      Timecop.freeze
      open_time = Time.now + 1.hour
      swarm.update(:opens_at => open_time)
      
      expect(swarm.opens_at).to eq(open_time)
    end

    it "should really be set to now, if asked to set it before now." do
      Timecop.freeze

      open_time = Time.now - 1.hour
      swarm.update(:opens_at => open_time)
      
      expect(swarm.opens_at).to eq(Time.now)
    end

    it "should raise an error if asked to set it after the close date" do
      Timecop.freeze

      open_time = Time.now - 1.hour
      close_time = Time.now - 2.hours
      
      expect { swarm.update(:opens_at => open_time, :closes_at => close_time) }.to raise_error TimeParadoxError
    end

    it "should not raise an error if there is no close date" do
      Timecop.freeze

      open_time = Time.now - 1.hour
      
      expect { swarm.update(:opens_at => open_time, :closes_at => nil) }.not_to raise_error
    end
  end

  describe "having its close date set" do
    let(:swarm) { Swarm.create() }
    it "should really be the time it was asked to be set to, if it's set to the future" do
      Timecop.freeze
      close_time = Time.now + 1.hour
      swarm.update(:closes_at => close_time)
      
      expect(swarm.closes_at).to eq(close_time)
    end

    it "should really be set to now, if asked to set it before now." do
      Timecop.freeze

      close_time = Time.now - 1.hour
      swarm.update(:closes_at => close_time)
      
      expect(swarm.closes_at).to eq(Time.now)
    end

    it "should raise a TimeParadoxError if asked to set it before the open date" do
      Timecop.freeze

      close_time = Time.now - 2.hours
      open_time = Time.now - 1.hour
      
      expect { swarm.update(:closes_at => close_time, :opens_at => open_time) }.to raise_error TimeParadoxError
    end

    it "should not raise an error if there is no open date" do
      Timecop.freeze

      close_time = Time.now - 1.hour
      
      expect { swarm.update(:opens_at => nil, :closes_at => close_time) }.not_to raise_error
    end
  end

  describe "that has already opened" do
    before  { Timecop.freeze }
    let(:swarm) { Swarm.create(:opens_at => (Time.now - 1.hour)) }

    describe "having its close date set" do
      it "should not alter the opened at date." do
        close_time = Time.now + 1.hour
        swarm.update(:closes_at => close_time)
        expect(swarm.opens_at).to eq(Time.now - 1.hour)
      end
    end
  end

  describe "that has been cloned" do
    let(:alice) { User.create }
    let(:bob) { User.create }
    let(:swarm) { Swarm.create(:name => 'Test Swarm',
                               :parent_swarm => nil,
                               :user => alice,
                               :opens_at => (Time.now - 1.hour)) }

    before { @new_swarm = swarm.clone_by(bob) }

    it "should not have an open time" do
      expect(@new_swarm.opens_at).to be_nil
    end

    it "should not have a close time" do
      expect(@new_swarm.closes_at).to be_nil
    end

    it "should have a parent swarm set" do
      expect(@new_swarm.parent_swarm).to eq(swarm)
    end

    it "should have the user set to be the cloning user" do
      expect(@new_swarm.user).to eq(bob)
    end

    it "should have an altered name" do
      expect(@new_swarm.name).to eq("Test Swarm (cloned)")
    end
  end

  describe "generating its collector url" do
    let(:swarm) { Swarm.create(:name => 'Test Swarm',
                               :opens_at => (Time.now - 1.hour)) }
    it "should generate the correct URL based upon its token" do
      expect(swarm.collector_url).to eq("http://collector.swarmize.com/swarms/#{swarm.token}")

    end
  end
end
