class Dummy
  def self.create_fake_user
    u = User.new
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name

    u.name = [first_name,last_name].join(" ")
    u.email = Faker::Internet.email(first_name)

    u.is_fake = true

    u.save
    u
  end

  def self.create_dummy_preopen_swarm(user, n=1)
    s = Dummy.create_dummy_swarm(user, (Time.now+n.days), nil)
   s 
  end

  def self.create_dummy_live_swarm(user, n=1)
    s = Dummy.create_dummy_swarm(user, (Time.now-n.days), (Time.now+n.days))
   s 
  end

  def self.create_dummy_closed_swarm(user, n=1)
    s = Dummy.create_dummy_swarm(user, (Time.now-(2*n).days), (Time.now-n.days))
    s
  end

  def self.create_dummy_swarm(user,opens,closes)
    s = Swarm.new
    s.user = user
    s.opens_at = opens
    s.closes_at = closes
    s.name = Faker::Lorem.sentence(2)
    s.description = Faker::Lorem.sentences(3).join(" ")
    s.save
    s
  end

  def self.destroy_fake_data
    fake_users = User.where(:is_fake => true)
    fake_users.each do |u|
      u.swarms.destroy_all
    end

    fake_users.destroy_all
  end

end
