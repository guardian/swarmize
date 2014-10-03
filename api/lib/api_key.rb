require 'aws-sdk'

class APIKey
  def self.all
    table.items
  end

  def self.client
    @@dynamo ||= AWS::DynamoDB.new(region: 'eu-west-1')
  end

  def self.table
    client.tables['api_keys'].load_schema
  end

  def self.exists_for_swarm(api_key, swarm_token)
    all.where(:swarm_token => swarm_token, :api_key => api_key).count > 0
  end
end

