class HomeController < ApplicationController
  def show
    @swarms_in_progress = Swarm.live.latest(5)
    @latest_complete_swarms = Swarm.closed.latest(5)
  end
end
