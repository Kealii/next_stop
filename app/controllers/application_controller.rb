class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  NEXT_STOP = "http://localhost:3001/api/v1"

  def search_response
    stop_id = params[:stop_id]
    @stop_name = params[:stop_name]
    departure_time = params[:departure_time]
    HTTParty.get("#{NEXT_STOP}/search", query: {stop_id: stop_id, departure_time: departure_time})
  end

  def departure_time(stop_time_json)
    Time.parse(stop_time_json['departure_time']).strftime('%l:%M %P')
  end

  def new_path(stop_time_json)
    {stop_id: stop_time_json['stop_id'], departure_time: stop_time_json['departure_time'], stop_name: stop_time_json['name']}
  end

  def new_route(route_json)
    Route.new(route_json['route_id'], route_json['route_short_name'])
  end

  def single_route
    route_id = params[:id]
    HTTParty.get("#{NEXT_STOP}/routes/#{route_id}")
  end

  def single_trip(trip_id)
    HTTParty.get("#{NEXT_STOP}/trips/#{trip_id}")
  end

  def routes
    HTTParty.get("#{NEXT_STOP}/routes")
  end

  def json_body(response)
    JSON.parse(response.body)
  end
end
