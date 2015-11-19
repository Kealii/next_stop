class WelcomeController < ApplicationController
  def index
    @routes = json_body(routes).map do |route_json|
      new_route(route_json)
    end
  end

  def near_by
    @routes = json_body(search_response).map do |route_json|
      route = new_route(route_json)
      route.departure_time = route_json['departure_time']
      route
    end
  end
end
