class APIToken
  def self.create(swarm_token, email)
    api_token = generate_token
    table.items.create(api_token: api_token,
                       swarm_token: swarm_token,
                       created_by: email,
                       created_at: Time.now.utc.to_s)
  end

  def self.delete(api_token)
    table.items[api_token].delete
  end

  def self.all
    table.items
  end

  def self.client
    @@dynamo ||= AWS::DynamoDB.new
  end

  def self.table
    client.tables['api_tokens'].load_schema
  end

  private

  def self.generate_token
    loop do
      random_token = SecureRandom.hex(8)
      break random_token unless table.items[random_token].exists?
    end
  end
end
