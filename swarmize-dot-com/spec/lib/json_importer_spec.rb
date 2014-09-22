require 'spec_helper'

RSpec.describe JSONImporter do
  before do
    @json = File.read('spec/lib/sample.json')
  end
  context 'importing from JSON' do
    it 'should create a swarm' do
      expect(JSONImporter).to receive(:create_swarm)
      JSONImporter.import!(@json)
    end
    it 'should create fields for that swarm' do
      mash = double()
      allow(JSONImporter).to receive(:create_swarm).and_return(mash)
      expect(JSONImporter).to receive(:create_fields_for_swarm)
      JSONImporter.import!(@json)
    end
  end
  context 'creating a swarm from a JSON mashie' do
    before do
      @mash = Hashie::Mash.new(JSON.parse(@json))
    end
    it "should create a swarm with the appropriate fields from the mash" do
      expect(Swarm).to receive(:create).with({:name => '#indyref survey',
                                              :description => 'Extracting data from the #indyref hashtag on Twitter, capturing numbers of #no, #voteno and #yes, #voteyes votes.',
                                              :opens_at => Time.parse("2014-09-13T19:46:04.575Z"),
                                              :closes_at => nil})
      JSONImporter.create_swarm(@mash)
    end
  end
  context 'creating the fields for a swarm from a JSON mashie' do
    before do
      @swarm = double(:token => 'abcdefgh')
    end
    it "should create the appropriate numbr of fields for the swarm" do
      @mash = Hashie::Mash.new(JSON.parse(@json))
      expect(SwarmField).to receive(:create).exactly(4).times
      JSONImporter.create_fields_for_swarm(@mash, @swarm)
    end
    it "should receive the correct data for the field" do
      sample_json = File.read('spec/lib/sample_field.json')
      @mash = Hashie::Mash.new(JSON.parse(sample_json))
      expect(SwarmField).to receive(:create).with(:field_index => 1,
                                                  :field_type => 'yesno',
                                                  :field_name => 'Are you for an independent Scotland?',
                                                  :field_code => 'are_you_for_an_independent_scotland',
                                                  :compulsory => true,
                                                  :swarm => @swarm,
                                                  :hint => nil,
                                                  :sample_value => nil,
                                                  :minimum => nil,
                                                  :maximum => nil,
                                                  :possible_values => nil)
      JSONImporter.create_fields_for_swarm(@mash, @swarm)
    end
    it "should receive the correct data a field with possible_values" do
      sample_json = File.read('spec/lib/sample_field_possible_values.json')
      @mash = Hashie::Mash.new(JSON.parse(sample_json))
      expect(SwarmField).to receive(:create).with(:field_index => 1,
                                                  :field_type => 'pick_one',
                                                  :field_name => 'Who did you just agree with?',
                                                  :field_code => 'who_did_you_just_agree_with',
                                                  :compulsory => true,
                                                  :swarm => @swarm,
                                                  :hint => nil,
                                                  :sample_value => nil,
                                                  :minimum => nil,
                                                  :maximum => nil,
                                                  :possible_values => ['David Cameron', 'Ed Miliband', 'Nick Clegg'])
      JSONImporter.create_fields_for_swarm(@mash, @swarm)
    end
  end
end
