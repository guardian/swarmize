class DynamoSync
  def self.sync(swarm)
    if Rails.env.production?
      @@dynamo ||= AWS::DynamoDB.new
      swarms_table = @@dynamo.tables['swarms'].load_schema

      if swarm.is_spiked
        delete(swarm)
      else
        swarms_table.items.create(token: swarm.token,
                                  definition: swarm.to_json)
      end
    end
  end

  def self.delete(swarm)
    if Rails.env.production?
      @@dynamo ||= AWS::DynamoDB.new
      swarms_table = @@dynamo.tables['swarms'].load_schema

      swarms_table.items[swarm.token].delete
    end
  end
end
