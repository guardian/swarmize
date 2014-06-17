require 'bundler/setup'
require 'sinatra/base'

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

class LiveDebate < Sinatra::Base
  enable :sessions
  set :sessions, :expire_after => 2592000

  swarm = SwarmApi.new("banana", "localhost", 9000)

  get '/' do
    unless session[:unique_key]
      session[:unique_key] = (Time.now.to_f * 10000000).to_i
    end

    haml :index, :locals => {:key => session[:unique_key]}
  end

  post '/endpoint' do
    data = params.merge({:ip => request.ip, :user_key => session[:unique_key], :timestamp => (Time.now.to_f * 1000000).to_i})

    # now send that to Swarm
    swarm.send(data)
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end

