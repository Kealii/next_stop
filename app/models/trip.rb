class Trip < Struct.new(:id, :stop_times, :service_id)

  def service
    {"WK" => 'weekday bus', "SA" => 'saturday bus'}[service_id]
  end

end