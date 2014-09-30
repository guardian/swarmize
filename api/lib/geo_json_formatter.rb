class GeoJSONFormatter
  def self.format(results, coords_key)
    results_with_latlong = results.select do |row|
      row[coords_key]
    end
    features = results_with_latlong.map do |row|
      properties = row.reject {|k| k == coords_key}
      {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: row[coords_key].map {|c| c.to_f}
        },
        properties: properties
      }
    end

    {type: 'FeatureCollection',
     features: features}
  end
end
