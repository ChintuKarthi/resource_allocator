# frozen_string_literal: true

require 'active_record'
require 'resource_allocator/helper/optimize_cpu.rb'

module MaximumPrice
  include OptimizeCPU
  # This method returns a JSON Response for Maximum 'X' Price affordable for 'Y' hours
  def self.get_price_hours_cost(region, hours, price)

    # call_flag to let optimize_servers method know that call is being made from MaximumPrice module
    # Stringifying and Inverting the keys so that price can be passed to optimize servers method.
    # Price and region cost is multplied by 1000 to make the cost as a whole number.
    call_flag = 1
    converted_east_cost = Hash[$region[:'us-east'].map { |k, v| [k, (v * 1000)] }]
    converted_west_cost = Hash[$region[:'us-west'].map { |k, v| [k, (v * 1000)] }]
    converted_asia_cost = Hash[$region[:'asia'].map { |k, v| [k, (v * 1000)] }]
    
    east_server = OptimizeCPU.optimize_servers(converted_east_cost.values, price*1000, $region[:'us-east'].stringify_keys.invert, call_flag)
    west_server = OptimizeCPU.optimize_servers(converted_west_cost.values, price*1000, $region[:'us-west'].stringify_keys.invert, call_flag)
    asia_server = OptimizeCPU.optimize_servers(converted_asia_cost.values, price*1000, $region[:'asia'].stringify_keys.invert, call_flag)

    east_hash = {}
    west_hash = {}
    asia_hash = {}
    if east_server.present?
      east_hash = {
        "region": "us-east",
        "total_cost": "$" + price.to_s,
        "servers": east_server
      }
    end
    if west_server.present?
      west_hash = {
        "region": "us-west",
        "total_cost": "$" + price.to_s,
        "servers": west_server
      }
    end
    if asia_server.present?
      asia_hash = {
        "region": "asia",
        "total_cost": "$" + price.to_s,
        "servers": asia_server
      }
    end
    maximum_price_output = [east_hash, west_hash, asia_hash]
    maximum_price_output = maximum_price_output.delete_if &:empty?
    maximum_price_output
  end
end
