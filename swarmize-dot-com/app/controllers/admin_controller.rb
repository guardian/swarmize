class AdminController < ApplicationController
  def dummy_up
    Dummy.destroy_fake_data
    5.times do
      Dummy.create_fake_user
    end
    do_create_dummy_swarms
    flash[:success] = "Fake users and swarms created."
    redirect_to admin_path
  end

  def delete_dummy
    Dummy.destroy_fake_data
    flash[:success] = "All fake users and swarms deleted."
    redirect_to admin_path
  end

  def create_dummy_users
    5.times do
      Dummy.create_fake_user
    end
    flash[:success] = "Made 5 dummy users."
    redirect_to admin_path
  end

  def create_dummy_swarms
    do_create_dummy_swarms
    flash[:success] = "Made dummy swarms."
    redirect_to admin_path
  end

  private

  def do_create_dummy_swarms
    5.times do |n|
      user = User.where(:is_fake => true).order("RANDOM()").first
      Dummy.create_dummy_preopen_swarm(user, n)
    end

    5.times do |n|
      user = User.where(:is_fake => true).order("RANDOM()").first
      Dummy.create_dummy_live_swarm(user, n)
    end

    5.times do |n|
      user = User.where(:is_fake => true).order("RANDOM()").first
      Dummy.create_dummy_closed_swarm(user, n)
    end
  end

end
