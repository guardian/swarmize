class HomeController < ApplicationController
  def show
    if @current_user
      @user_swarms_yet_to_launch = @current_user.swarms.yet_to_launch.latest(5)
      @user_swarms_in_progress = @current_user.swarms.live.latest(5)
      @user_completed_swarms = @current_user.swarms.closed.latest(5)
    end
    @swarms_in_progress = Swarm.live.latest(5)
    @latest_complete_swarms = Swarm.closed.latest(5)
  end
end
