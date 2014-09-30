require 'json'
require 'aws-sdk'

class DynamoSwarm
  attr_reader :token, :definition
  def initialize(token)
    @token = token
    
    swarms_table = DynamoSwarm.client.tables['swarms'].load_schema
    swarm = swarms_table.items[@token]
    @definition = JSON.parse(swarm.attributes['definition'])

    self
  end

  def search
    #if draft?
      #SwarmizeSearch.new("#{token}_draft")
    #else
      SwarmizeSearch.new(token)
    #end
  end

  def self.client
    @@dynamo ||= AWS::DynamoDB.new(region: 'eu-west-1')
  end

end
