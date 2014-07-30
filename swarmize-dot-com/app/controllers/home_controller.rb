class HomeController < ApplicationController
  def show
    @swarms = Swarm.latest(5)
  end
end
