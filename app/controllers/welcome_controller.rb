class WelcomeController < ApplicationController
  def index
    @routes = json_body(routes).map do |route|
      Route.new(route['route_id'], route['route_short_name'])
    end
  end

  def near_by
    stop_id = params[:stop_id]
    @stop_name = params[:stop_name]
    departure_time = params[:departure_time]
    response = HTTParty.get("#{NEXT_STOP}/search", query: {stop_id: stop_id, departure_time: departure_time})

    @routes = json_body(response).map do |route_json|
      route = Route.new(route_json['route_id'], route_json['route_short_name'])
      route.departure_time = route_json['departure_time']
      route
    end
  end
end
