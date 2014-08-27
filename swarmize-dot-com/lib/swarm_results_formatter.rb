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
      @swarm.swarm_fields.each do |f|
        headers << f.field_name
        if f.derived_field_suffixes
          f.derived_field_suffixes.each do |df|
            headers << "#{f.field_name} [#{df}]"
          end
        end
      end
      csv << headers

      #now, add all the results
      @raw_results.each do |r|
        row = []
        row << format_timestamp(r.timestamp)
        @swarm.swarm_fields.each do |field|
          row << r.send(field.field_code)
          if field.derived_field_codes
            field.derived_field_codes.each do |df|
              row << r.send(df)
            end
          end
        end
        csv << row
      end
    end

    output
  end

  def to_public_csv
    output = CSV.generate do |csv|
      # first, add the headers
      headers = []
      headers << "Timestamp"
      @swarm.swarm_fields.each do |f|
        headers << f.field_name
        if f.derived_field_suffixes
          f.derived_field_suffixes.each do |df|
            headers << "#{f.field_name} [#{df}]"
          end
        end
      end
      csv << headers

      #now, add all the results
      @raw_results.each do |r|
        row = []
        row << format_timestamp(r.timestamp)
        @swarm.swarm_fields.each do |field|
          if field.redacted?
            row << 'Redacted'
          else
            row << r.send(field.field_code)
          end

          if field.derived_field_codes
            field.derived_field_codes.each do |df|
              if field.redacted?
                row << 'Redacted'
              else
                row << r.send(df)
              end
            end
          end
        end
        csv << row
      end
    end

    output
  end
end

