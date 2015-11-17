class Route < Struct.new(:id, :short_name)
  attr_accessor :departure_time
end