class WelcomeController < ApplicationController
  # NEXT_STOP = "http://nextstopapi-1507.herokuapp.com/api/v1"
  NEXT_STOP = "http://localhost:3001/api/v1"
  def index
    response = HTTParty.get("#{NEXT_STOP}/routes")
    @routes = JSON.parse(response.body).map do |route|
      Route.new(route['route_id'], route['route_short_name'])
    end
  end

  def near_by
    stop_id = params[:stop_id]
    departure_time = params[:departure_time]
    response = HTTParty.get("#{NEXT_STOP}/search", query: {stop_id: stop_id, departure_time: departure_time})

    @routes = JSON.parse(response.body).map do |route_json|
      r = Route.new(route_json['route_id'], route_json['route_short_name'])
      r.departure_time = route_json['departure_time']
      r
    end

  end

  def route
    route_id = params[:route][:id]
    response = HTTParty.get("#{NEXT_STOP}/routes/#{route_id}")
    route_json = JSON.parse(response.body)
    @route = Route.new(route_json['route_id'], route_json['route_short_name'])

    @trips = route_json['trips'].first(5).map do |trip_json|
      trip_response = HTTParty.get("#{NEXT_STOP}/trips/#{trip_json['trip_id']}")
      stop_times = JSON.parse(trip_response.body)['stop_times'].map do |stop_time|
      # stop_times = trip_json['stop_times'].map do |stop_time|
        StopTime.new(stop_time['departure_time'], stop_time['name'], stop_time['stop_id'])
      end

      Trip.new(trip_json['trip_id'], stop_times, trip_json['service_id'])
    end

    @stops = route_json['stops'].map do |stop|
      Stop.new(stop['stop_id'], stop['stop_name'])
    end
  end
end
