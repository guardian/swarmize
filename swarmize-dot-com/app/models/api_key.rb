class APIKey
  def self.create(swarm_token, email)
    api_key = generate_key
    table.items.create(api_key: api_key,
                       swarm_token: swarm_token,
                       created_by: email,
                       created_at: Time.now.utc.to_s)
  end

  def self.delete(api_key)
    table.items[api_key].delete
  end

  def self.all
    table.items
  end

  def self.client
    @@dynamo ||= AWS::DynamoDB.new
  end

  def self.table
    client.tables['api_keys'].load_schema
  end

  private

  def self.generate_key
    loop do
      random_key = SecureRandom.hex(8)
      break random_key unless table.items[random_key].exists?
    end
  end
end
