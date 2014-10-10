class OembedController < ApplicationController
  def show
    if params[:format] == 'xml'
      render :status => 501, :text => 'Format not supported'
      return
    end

    url = params[:url]
    # check URL matches scheme
    unless SwarmizeOembed.matches_scheme(url)
      raise ActionController::RoutingError.new("URL doesn't match OEmbed scheme")
    end

    # find token
    token = SwarmizeOembed.extract_token(url)
    swarm = Swarm.find_by(token: token)
    unless swarm
      raise ActionController::RoutingError.new('Not Found')
    end

    require 'open-uri'


    # generate JSON
    render :json => SwarmizeOembed.for(swarm, {root_url: root_url,
                                               maxwidth: params[:maxwidth],
                                               maxheight: params[:maxheight]})
  end
end
