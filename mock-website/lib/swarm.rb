class Swarm
  attr_reader :key, :name, :search
  def initialize(key,name)
    @key = key
    @name = name
    @search = SwarmizeSearch.new(key)
  end
end
