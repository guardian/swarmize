require 'csv'
include ApplicationHelper

class SwarmCSVTool
  attr_reader :swarm

  def initialize(swarm)
    @swarm = swarm

    @header_hash = {timestamp: 'Timestamp'}
    @swarm.swarm_fields.each do |f|
      @header_hash[f.field_code.to_sym] = f.field_name
      if f.derived_field_suffixes
        f.derived_field_suffixes.each do |df|
          @header_hash["#{f.field_code}#{df}"] = "#{f.field_name} [#{df}]"
        end
      end
    end
  end

  def headers
    # true indicates it's a header
    CSV::Row.new(@header_hash.keys, @header_hash.values, true)
  end

  def result_to_row(result)
    cols = @header_hash.keys.map do |key|
      result.send(key)
    end
    CSV::Row.new(@header_hash.keys, cols, false)
  end

  def result_to_public_row(result)
    public_safe_keys = @header_hash.keys.select do |key|
      @swarm.public_field_codes.include?(key.to_s)
    end

    cols = public_safe_keys.map do |key|
      result.send(key)
    end
    CSV::Row.new(@header_hash.keys, cols, false)
  end
end

