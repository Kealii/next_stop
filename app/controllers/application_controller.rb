class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :response_body, :routes

  NEXT_STOP = "http://localhost:3001/api/v1"

  def single_route
    route_id = params[:route][:id]
    HTTParty.get("#{NEXT_STOP}/routes/#{route_id}")
  end

  def routes
    HTTParty.get("#{NEXT_STOP}/routes")
  end

  def json_body(response)
    JSON.parse(response.body)
  end
end
