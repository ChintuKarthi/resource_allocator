# frozen_string_literal: true

require 'active_record'
require 'resource_allocator/helper/optimize_cpu.rb'

module MinimumCpu
  include OptimizeCPU
  # This method returns a JSON Response for minimum 'X' cpus requested for 'Y' hours
  def self.get_cpu_hours_cost(server_value, region, hours, cpus)
    # This method takes the server_keys (region specific server size) as a input.
    # Return an array of their equivalent numeric values by comparing it with $server_value
    def self.get_server_type(server_keys)
      server_array = Array.new()
      server_keys.each_with_index do |k, index|
        server_array[index] = $server_value.invert[k.to_s]
      end
      server_array
    end

    # This method takes optimized servers and returns their total cost
    # Calculation based on the region, cost per hour and no of hours.
    # cost - An Array of region specific cost values
    # server - Optimized servers values
    # hours - total no of hours expected to run
    def self.get_region_cost(server, cost, hours)
      server_cost = 0
      server.each do|key, value|
        if cost[key].present?
          server_cost = server_cost + (cost[key] * value * hours)
        end
      end
      server_cost
    end


    east_keys = get_server_type($region[:'us-east'].stringify_keys.keys)
    west_keys = get_server_type($region[:'us-west'].stringify_keys.keys)
    asia_keys = get_server_type($region[:'asia'].stringify_keys.keys)

    east_server = OptimizeCPU.optimize_servers(east_keys, cpus, $server_value)
    west_server = OptimizeCPU.optimize_servers(west_keys, cpus, $server_value)
    asia_server = OptimizeCPU.optimize_servers(asia_keys, cpus, $server_value)


    east_cost = get_region_cost(east_server, $region[:'us-east'].stringify_keys, hours)
    west_cost = get_region_cost(west_server, $region[:'us-west'].stringify_keys, hours)
    asia_cost = get_region_cost(asia_server, $region[:'asia'].stringify_keys, hours)

    total_cost = east_cost + west_cost + asia_cost

    final_response = [
      {
        "region": "us-east",
        "total_cost": "$" + east_cost.round(2).to_s,
        "servers": east_server
      },
      {
        "region": "us-west",
        "total_cost": "$" + west_cost.round(2).to_s,
        "servers": west_server
      },
      {
        "region": "asia",
        "total_cost": "$" + asia_cost.round(2).to_s,
        "servers": asia_server
      }
    ]

    final_response.to_json
  end
end
