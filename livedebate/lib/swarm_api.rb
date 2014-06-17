class SwarmApi
  require 'json'
  require 'net/http'

  attr_reader :swarmkey, :hostname, :port

  def initialize(swarmkey, hostname, port)
    @swarmkey = swarmkey
    @hostname = hostname
    @port = port
  end

  def send(data)
    path = "/swarm/#{swarmkey}"

    payload = data.to_json

    req = Net::HTTP::Post.new(path, {'Content-Type' =>'application/json'})
    req.body = payload

    response = Net::HTTP.new(hostname, port).start {|http| http.request(req) }
    puts "Response #{response.code} #{response.message}:
    #{response.body}"
  end
end

