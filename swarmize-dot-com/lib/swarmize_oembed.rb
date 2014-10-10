require 'open-uri'

class SwarmizeOembed
  
  def self.matches_scheme(url)
    url =~ /http:\/\/alpha\.swarmize\.com\/swarms\/(\w{8})\/?/
  end

  def self.extract_token(url)
    url.gsub("http://alpha.swarmize.com/swarms/", "").split("/").first
  end

  def self.for(swarm, options={})
    if options[:maxwidth]
      width = options[:maxwidth].to_i
    else
      width = 400
    end

    if options[:maxheight]
      height = options[:maxheight].to_i
    else
      height = swarm.estimate_form_height
    end

    src = "http://alpha.swarmize.com/swarms/#{swarm.token}/embed"
    html = "<iframe src='#{src}' width='#{width}' height='#{height}' frameBorder='0' seamless='seamless'></iframe>"

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
