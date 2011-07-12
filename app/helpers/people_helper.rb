module PeopleHelper
  def google_map_url(location)
    url = "http://maps.google.com/maps/api/staticmap?size=450x300&sensor=false"

    location.restaurants.each_with_index do |restaurant, index|
      url += "&markers=color:red%7Clabel:#{google_map_pin_label(index)}%7C#{restaurant.latitude}%2C#{restaurant.longitude}"
    end

    url
  end

  def google_map_pin_label(index)
    ('A'.ord + (index % 26)).chr
  end
end
