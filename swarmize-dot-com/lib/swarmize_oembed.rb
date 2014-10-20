require 'open-uri'

class SwarmizeOembed
  class << self
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::AssetUrlHelper
  end

  def self.matches_scheme(url)
    url =~ /http:\/\/alpha\.swarmize\.com\/swarms\/(\w{8})\/?/
  end

  def self.extract_token(url)
    url.gsub("http://alpha.swarmize.com/swarms/", "").split("/").first
  end

  def self.for(swarm, options={})
    #if options[:maxwidth]
      #width = options[:maxwidth].to_i
    #else
      #width = 400
    #end

    #if options[:maxheight]
      #height = options[:maxheight].to_i
    #else
      #height = swarm.estimate_form_height
    #end

    html = "<script type='text/javascript' src='#{asset_url('swarmize-embed.js')}'></script><div id='swarmize-embedded-form' data-swarmize-token='#{swarm.token}'><a href='#{embed_swarm_url(swarm, :host => 'http://cdn.swarmize.com')}'>Fill out your answers on swarmize.com</a></div>"

    {
      type: "rich",
      version: "1.0",
      title: swarm.name,
      provider_name: "Swarmize",
      provider_url: "http://alpha.swarmize.com", 
      width: width,
      height: height,
      html: html
    }.to_json
  end
end
