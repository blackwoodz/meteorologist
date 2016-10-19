require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    @street_address_without_spaces = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the variable @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the variable @street_address_without_spaces.
    # ==========================================================================

    url_google_maps = "https://maps.googleapis.com/maps/api/geocode/json?address=" + @street_address_without_spaces
    parsed_maps_data = JSON.parse(open(url_google_maps).read)

    @latitude = parsed_maps_data["results"][0]["geometry"]["location"]["lat"]

    @longitude = parsed_maps_data["results"][0]["geometry"]["location"]["lng"]

    url_darksky = "https://api.darksky.net/forecast/144ff4e7c7893bf74c565723852e0da3/" + @latitude.to_s + "," + @longitude.to_s
    parsed_weather_data = JSON.parse(open(url_darksky).read)

    @current_temperature = parsed_weather_data["currently"]["temperature"]

    @current_summary = parsed_weather_data["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_weather_data["minutely"]["summary"]

    @summary_of_next_several_hours = parsed_weather_data["hourly"]["summary"]

    @summary_of_next_several_days = parsed_weather_data["daily"]["summary"]

    render("meteorologist/street_to_weather.html.erb")
  end
end
