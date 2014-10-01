require 'aws-sdk'

class APIToken
  def self.all
    table.items
  end

  def self.client
    @@dynamo ||= AWS::DynamoDB.new(region: 'eu-west-1')
  end

  def self.table
    client.tables['api_tokens'].load_schema
  end

  def self.exists_for_swarm(token, swarm_token)
    all.where(:swarm_token => swarm_token, :api_token => token).count > 0
  end
end
