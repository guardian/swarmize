require 'json'
require 'net/http'

class SwarmApi
  attr_reader :swarmkey, :hostname, :port

  def initialize(swarmkey, hostname, port=80)
    @swarmkey = swarmkey
    @hostname = hostname
    @port = port
  end

  def send(data)
    path = "/swarm/#{swarmkey}"

    payload = data.to_json

    req = Net::HTTP::Post.new(path, {'Content-Type' =>'application/json'})
    req.body = payload

    response = Net::HTTP.new(hostname, port).start do |http| 
      http.request(req)
    end

    puts "Response #{response.code} #{response.message}:
    #{response.body}"
  end
end

