require 'json'
require 'hashie'

# TODO
# export token in json, duh
# write specs

class JSONImporter
  def self.import!(json, user=nil)
    json_mash = Hashie::Mash.new(JSON.parse(json))

    swarm = create_swarm(json_mash, user)
    create_fields_for_swarm(json_mash, swarm)

    swarm
  end

  def self.create_swarm(json, user=nil)
    if json.opens_at
      opens_at = Time.parse(json.opens_at)
    else
      opens_at = nil
    end

    if json.closes_at
      closes_at = Time.parse(json.closes_at)
    else
      closes_at = nil
    end

    swarm = Swarm.create(:name => json.name + " [IMPORTED]",
                         :description => json.description,
                         :opens_at => opens_at,
                         :closes_at => closes_at,
                         :token => json.token)

    if user
      AccessPermission.create(:swarm => swarm,
                              :user => user,
                              :email => user.email,
                              :is_owner => true)
    end

    swarm
  end

  def self.create_fields_for_swarm(json, swarm)
    json.fields.each_with_index do |field, i|
      if field.possible_values
        possible_values = field.possible_values.map {|k,v| v}
      else
        possible_values = nil
      end
      SwarmField.create(:field_index => i+1,
                        :field_type => field.field_type,
                        :field_name => field.field_name,
                        :field_code => field.field_name_code,
                        :hint => field.hint,
                        :sample_value => field.sample_value,
                        :compulsory => field.compulsory,
                        :minimum => field.minimum,
                        :maximum => field.maximum,
                        :possible_values => possible_values,
                        :swarm => swarm)
    end

  end
end
