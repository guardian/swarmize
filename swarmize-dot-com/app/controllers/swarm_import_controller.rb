require 'open-uri'

class SwarmImportController < ApplicationController
  before_filter :check_for_user

  def new
  end

  def create
    # if url doesn't end .json, add it
    url = params[:url]
    unless url =~ /(.*)\.json$/
      url = "#{url}.json"
    end

    json = open(url).read

    swarm = JSONImporter.import!(json, @current_user)
    flash[:success] = "Swarm created"
    redirect_to swarm
  end
end
