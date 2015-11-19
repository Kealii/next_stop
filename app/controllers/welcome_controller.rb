class WelcomeController < ApplicationController
  def index
    @routes = json_body(routes).map do |route|
      Route.new(route['route_id'], route['route_short_name'])
    end
  end

  def route
    route_json = json_body(single_route)
    @route = Route.new(route_json['route_id'], route_json['route_short_name'])

    @trips = route_json['trips'].first(5).map do |trip_json|
      trip_response = HTTParty.get("#{NEXT_STOP}/trips/#{trip_json['trip_id']}")
      stop_times = json_body(trip_response)['stop_times'].map do |stop_time|
        StopTime.new(stop_time['departure_time'], stop_time['name'], stop_time['stop_id'])
      end
      Trip.new(trip_json['trip_id'], stop_times)
    end
  end

  def near_by
    stop_id = params[:stop_id]
    departure_time = params[:departure_time]
    response = HTTParty.get("#{NEXT_STOP}/search", query: {stop_id: stop_id, departure_time: departure_time})

    @routes = json_body(response).map do |route_json|
      route = Route.new(route_json['route_id'], route_json['route_short_name'])
      route.departure_time = route_json['departure_time']
      route
    end
  end
end
