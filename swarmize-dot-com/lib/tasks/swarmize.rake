require 'faker'

namespace :swarmize do
  namespace :development do
    desc "Insert dummy data"
    task :insert_dummy_data => [:destroy_fake_data,:create_fake_users,:insert_dummy_swarms]

    desc "Destroy fake data"
    task :destroy_fake_data => :environment do
      fake_users = User.where(:is_fake => true)
      fake_users.each do |u|
        u.swarms.destroy_all
      end

      fake_users.destroy_all
    end

    desc "Insert dummy swarms"
    task :insert_dummy_swarms => [:insert_dummy_preopen_swarms, :insert_dummy_live_swarms, :insert_dummy_closed_swarms]

    desc "Insert some dummy yet-to-open swarms"
    task :insert_dummy_preopen_swarms => :environment do
      5.times do |n|
        user = User.where(:is_fake => true).order("RANDOM()").first
        create_dummy_swarm(user, (Time.now+n.days), nil)
      end
    end

    desc "Insert some dummy live swarms"
    task :insert_dummy_live_swarms => :environment do
      5.times do |n|
        user = User.where(:is_fake => true).order("RANDOM()").first
        create_dummy_swarm(user, (Time.now-n.days), (Time.now+n.days))
      end
    end

    desc "Insert some dummy closed swarms"
    task :insert_dummy_closed_swarms => :environment do
      5.times do |n|
        user = User.where(:is_fake => true).order("RANDOM()").first
        create_dummy_swarm(user, (Time.now-(2*n).days), (Time.now-n.days))
      end
    end

    desc "Insert some fake users"
    task :create_fake_users => :environment do
      5.times do
        u = User.new
        first_name = Faker::Name.first_name
        last_name = Faker::Name.last_name

        u.name = [first_name,last_name].join(" ")
        u.email = Faker::Internet.email(first_name)

        u.is_fake = true

        u.save
      end
    end
  end
end

def create_dummy_swarm(user,opens,closes)
  s = Swarm.new
  s.user = user
  s.opens_at = opens
  s.closes_at = closes
  s.name = Faker::Lorem.sentence(2)
  s.description = Faker::Lorem.sentences(3).join(" ")
  s.save
end
