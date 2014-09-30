class GeoJSONFormatter
  def self.format(results, options={})
    results_with_latlong = results.select do |row|
      row[options[:coords_key]]
    end
    features = results_with_latlong.map do |row|
      if options[:properties_keys]
        prop_keys = options[:properties_keys].split(",")
        properties = row.select {|k| prop_keys.include? k }
      else
        properties = {}
      end
      {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: row[options[:coords_key]].map {|c| c.to_f}
        },
        properties: properties
      }
    end

    {type: 'FeatureCollection',
     features: features}
  end
end
