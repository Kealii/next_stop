class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  NEXT_STOP = "http://localhost:3001/api/v1"

  def routes
    HTTParty.get("#{NEXT_STOP}/routes")
  end

  def json_body(response)
    JSON.parse(response.body)
  end
end
