require 'csv'
include ApplicationHelper

class SwarmResultsFormatter
  attr_reader :raw_results, :swarm

  def initialize(swarm,raw_result_set)
    @swarm = swarm
    @raw_results = raw_result_set
  end

  def to_csv
    output = CSV.generate do |csv|
      # first, add the headers
      headers = []
      headers << "Timestamp"
      headers << @swarm.fields.map {|f| f['field_name']}
      csv << headers

      #now, add all the results
      @raw_results.each do |r|
        row = []
        row << format_timestamp(r.timestamp)
        @swarm.fields.each do |field|
          row << r.send(field['field_name'].parameterize.underscore)
        end
        csv << row
      end
    end

    output
  end
end

