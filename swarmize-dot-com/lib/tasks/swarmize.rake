require 'faker'

namespace :swarmize do
  namespace :development do
    desc "Insert dummy data"
    task :dummy_up => [:destroy_fake_data,:create_fake_users,:insert_dummy_swarms]

    desc "Destroy fake data"
    task :destroy_fake_data => :environment do
      puts "Destroying all old data."
      Dummy.destroy_fake_data
    end

    desc "Insert dummy swarms"
    task :insert_dummy_swarms => [:insert_dummy_preopen_swarms, :insert_dummy_live_swarms, :insert_dummy_closed_swarms]

    desc "Insert some dummy yet-to-open swarms"
    task :insert_dummy_preopen_swarms => :environment do
      5.times do |n|
        user = User.where(:is_fake => true).order("RANDOM()").first
        s = Dummy.create_dummy_preopen_swarm(user, n)
        puts "Created #{s.name}"
      end
    end

    desc "Insert some dummy live swarms"
    task :insert_dummy_live_swarms => :environment do
      5.times do |n|
        user = User.where(:is_fake => true).order("RANDOM()").first
        s = Dummy.create_dummy_live_swarm(user, n)
        puts "Created #{s.name}"
      end
    end

    desc "Insert some dummy closed swarms"
    task :insert_dummy_closed_swarms => :environment do
      5.times do |n|
        user = User.where(:is_fake => true).order("RANDOM()").first
        s = Dummy.create_dummy_closed_swarm(user, n)
        puts "Created #{s.name}"
      end
    end

    desc "Insert some fake users"
    task :create_fake_users => :environment do
      5.times do
        u = Dummy.create_fake_user
        puts "Created #{u.name}"
      end
    end
  end
end

