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
    results = @header_hash.keys.map do |key|
      result.send(key)
    end
    CSV::Row.new(@header_hash.keys, results, false)
  end

  def to_csv
    output = CSV.generate do |csv|
      # first, add the headers, and the field codes
      headers = []
      field_codes = []
      headers << "Timestamp"
      field_codes << 'timestamp'
      @swarm.swarm_fields.each do |f|
        headers << f.field_name
        field_codes << f.field_code
        if f.derived_field_suffixes
          f.derived_field_suffixes.each do |df|
            headers << "#{f.field_name} [#{df}]"
            field_codes << "#{f.field_code}#{df}"
          end
        end
      end
      csv << headers
      csv << field_codes

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
      field_codes = []
      headers << "Timestamp"
      field_codes << 'timestamp'

      @swarm.swarm_fields.each do |f|
        headers << f.field_name
        if f.derived_field_suffixes
          f.derived_field_suffixes.each do |df|
            headers << "#{f.field_name} [#{df}]"
            field_codes << "#{f.field_code}#{df}"
          end
        end
      end
      csv << headers
      csv << field_codes

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

