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

    desc "Insert tokens for swarms with no tokens"
    task :backfill_tokens => :environment do
      require 'securerandom'

      Swarm.where(:token => nil).each do |swarm|
        t = SecureRandom.urlsafe_base64(6)
        until (t.length == 8) && !Swarm.find_by_token(t)
          t = SecureRandom.urlsafe_base64(6)
        end

        swarm.token = t
        swarm.save
      end
    end

    desc "Backfill SwarmField objects for swarms"
    task :backfill_fields => :environment do
      Swarm.all.each do |swarm|
        if swarm.fields && swarm.fields.any?
          swarm.fields.each do |original_field|
            sf = swarm.swarm_fields.new
            sf.field_index = original_field['index']
            sf.field_type = original_field['field_type']
            sf.field_name = original_field['field_name']
            sf.hint = original_field['hint']
            sf.sample_value = original_field['sample_value']
            sf.compulsory = original_field['compulsory'] == '1'
            sf.possible_values = original_field['possible_values']
            sf.minimum = original_field['minimum']
            sf.maximum = original_field['maximum']
            sf.save rescue p original_field
          end
        end
        print "."
      end
      puts
    end

    desc "Destroy all SwarmFields"
    task :destroy_fields => :environment do
      SwarmField.destroy_all
    end
  end
end

