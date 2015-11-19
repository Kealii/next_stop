class RoutesController < ApplicationController
  def index
    id, name = params[:route].split('_')
    @route = Route.new(id, name)
  end

  def show
    route_id = params[:id]
    response = HTTParty.get("#{NEXT_STOP}/routes/#{route_id}")
    route_json = JSON.parse(response.body)
    @route = Route.new(route_json['route_id'], route_json['route_short_name'])

    @trips = route_json['trips'].first(3).map do |trip_json|
      trip_response = HTTParty.get("#{NEXT_STOP}/trips/#{trip_json['trip_id']}")
      stop_times = json_body(trip_response)['stop_times'].map do |stop_time_json|
        departure_time = Time.parse(stop_time_json['departure_time']).strftime('%l:%M %P')
        path = near_by_path(stop_id: stop_time_json['stop_id'], departure_time: stop_time_json['departure_time'])
        StopTime.new(departure_time, stop_time_json['name'], stop_time_json['stop_id'], path)
      end
      Trip.new(trip_json['trip_id'], stop_times)
    end

    render json: @trips
  end
end