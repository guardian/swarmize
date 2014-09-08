#! /usr/bin/env ruby

require 'json'
require 'csv'
require 'open-uri'
require 'httparty'

class SwarmizeParty
  include HTTParty
  base_uri 'http://collector.swarmize.com'

  def self.hit(token,who_they_agreed_with,how_they_vote,postcode,key)
    options = {
      body: {
        what_s_your_postcode: postcode,
        how_do_you_plan_to_vote_at_the_next_general_election: how_they_vote,
        who_did_you_just_agree_with: who_they_agreed_with,
        unique_user_key: key
      }
    }
    self.post("/swarms/#{token}", options)
  end
end

unless ARGV[0] && ARGV[1] && ARGV[2] && ARGV[3]
  puts "Usage: ./bombard.rb swarm_token participant_count hit_count bombard_duration_in_seconds"
  puts "eg: ./bombard.rb abcdefgh 10000 10 3600"
  exit
end

# first: extract the arguments

token = ARGV[0]
participant_count = ARGV[1].to_i
hit_count = ARGV[2].to_i
bombard_duration = ARGV[3].to_i

# now, setup the swarm data, and confirm it's open

swarm_url = "http://alpha.swarmize.com/swarms/#{token}.json"

swarm_details = JSON.load(open(swarm_url))

unless swarm_details['opens_at'] 
  puts "Swarm must be open in order to bombard."
  exit
end

# OK: let's set up some participants

postcodes = CSV.read('postcodes.csv')
postcodes.shift # shift off the headers

possible_votes = %w{conservative labour liberal_democrat green ukip other}
possible_hits = %w{david_cameron ed_miliband nick_clegg}

puts "Setting up participants"
participants = participant_count.times.map do |i|
  random_postcode = postcodes.sample
  person = {postcode: random_postcode.first,
            intent: possible_votes.sample}
  person
end
puts "Participants all set up"

swarm_opens = Time.parse(swarm_details['opens_at'])

puts "Setting up hits"
hits = [] 
participants.each_with_index do |p, i|
  hit_count.times do |c|
    h = {hit: possible_hits.sample,
         hit_time: rand(bombard_duration),
         user_id: i,
         intent: p[:intent],
         postcode: p[:postcode]
    }
    hits << h
  end
end
puts "Hits all set up"
puts

hits = hits.sort_by {|h| h[:hit_time]}

puts "*** BOMBARD STARTING @ #{Time.now}"

bombard_duration.times do |i|
  hits_to_perform = hits.select {|h| h[:hit_time] == i}
  hits_to_perform.each do |hit|
    SwarmizeParty.hit(token,hit[:hit],hit[:intent],hit[:postcode],hit[:user_id])
    print "."
  end
  sleep 1
end
puts
puts "*** BOMBARD COMPLETE @ #{Time.now}"
