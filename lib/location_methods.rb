module LocationMethods
  
  include Geokit::Geocoders
  
  def latlng
    "#{self.lat}, #{self.lng}"
  end

  # TODO figure out how to use this method.
  # Right now it attempts to find the nearest address which causes the markers to snap to the closest road
  # Should attempt to parse out a lat and lng and only pass it to query if one is not found
  def set_lat_lng_from_location
    lat_lng = Geokit::LatLng.normalize(self.location)
    if lat_lng
      self.lat = lat_lng.lat
      self.lng = lat_lng.lng
    else
      self.lat, self.lng = query_location_lat_long
    end
  end
  
  # This method will attempt to geocode an address. Even if you give it a latitude and longitute
  # it will attempt to generate a new lat,lng for the closest address which can be problematic
  # if you attempting to specify a location not close to a known address since it will snap to the 
  # nearest valid address which is sometimes quite a long ways away.
  def query_location_lat_long
    loc = MultiGeocoder.geocode(location)
    [loc.lat, loc.lng]
  end
  
end
