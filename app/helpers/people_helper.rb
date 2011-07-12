module PeopleHelper
  def google_map_marker(color, label, lat, lng)
    "markers=color:#{color}%7Clabel:#{label}%7C#{lat}%2C#{lng}"
  end

  def google_map_url(location)
    url = "http://maps.google.com/maps/api/staticmap?size=450x300&sensor=false"

    url += "&" + google_map_marker("green", "", location.latitude, location.longitude)
    location.restaurants.each_with_index do |restaurant, index|
      url += "&" + google_map_marker("red", google_map_pin_label(index), restaurant.latitude, restaurant.longitude)
    end

    url
  end

  def google_map_pin_label(index)
    ('A'.ord + (index % 26)).chr
  end
end
