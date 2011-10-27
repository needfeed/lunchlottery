module Geocoder
  module Lookup
    class Base
    end

    class Google < Base
      private
      def fetch_raw_data(query, reverse = false)
         <<-JSON
           {
            "status": "OK",
            "results": [ {
              "types": [ "street_address" ],
              "formatted_address": "45 Main Street, Long Road, Neverland, England",
              "address_components": [ {
                "long_name": "45 Main Street, Long Road",
                "short_name": "45 Main Street, Long Road",
                "types": [ "route" ]
              }, {
                "long_name": "Neverland",
                "short_name": "Neverland",
                "types": [ "city", "political" ]
              }, {
                "long_name": "England",
                "short_name": "UK",
                "types": [ "country", "political" ]
              } ],
              "geometry": {
                "location": {
                  "lat": 37.77572,
                  "lng": -132.0841430
                }
              }
            } ]
          }
        JSON
      end
    end
  end
end