class RoutesController < ApplicationController
  def index
    id, name = params[:route].split('_')
    @route = Route.new(id, name)
  end

  def show
    route_json = json_body(single_route)
    @route = new_route(route_json)

    @trips = route_json['trips'].first(3).map do |trip_json|
      trip_response = single_trip(trip_json['trip_id'])
      stop_times = json_body(trip_response)['stop_times'].map do |stop_time_json|
        path = near_by_path(new_path(stop_time_json))
        StopTime.new(departure_time(stop_time_json), stop_time_json['name'], stop_time_json['stop_id'], path)
      end
      Trip.new(trip_json['trip_id'], stop_times)
    end

    render json: @trips
  end
end