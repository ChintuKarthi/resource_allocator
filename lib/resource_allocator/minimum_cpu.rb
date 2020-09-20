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


    east_keys = get_server_type($region[:'us-east'].stringify_keys.keys)
    west_keys = get_server_type($region[:'us-west'].stringify_keys.keys)
    asia_keys = get_server_type($region[:'asia'].stringify_keys.keys)

    # call_flag is to identify from which module the optimize_servers method is called.
    # 0 - MinimumCpu
    call_flag = 0
    east_server = OptimizeCPU.optimize_servers(east_keys, cpus, $server_value, call_flag)
    west_server = OptimizeCPU.optimize_servers(west_keys, cpus, $server_value, call_flag)
    asia_server = OptimizeCPU.optimize_servers(asia_keys, cpus, $server_value, call_flag)



    east_cost = OptimizeCPU.get_region_cost(east_server, $region[:'us-east'].stringify_keys, hours)
    west_cost = OptimizeCPU.get_region_cost(west_server, $region[:'us-west'].stringify_keys, hours)
    asia_cost = OptimizeCPU.get_region_cost(asia_server, $region[:'asia'].stringify_keys, hours)

    total_cost = east_cost + west_cost + asia_cost

    east_hash = {}
    west_hash = {}
    asia_hash = {}
    if east_cost.present?
      east_hash = {
        "region": "us-east",
        "total_cost": "$" + east_cost.round(2).to_s,
        "servers": east_server
      }
    end
    if west_cost.present?
      west_hash = {
        "region": "us-west",
        "total_cost": "$" + west_cost.round(2).to_s,
        "servers": west_server
      }
    end
    if asia_hash.present?
      asia_hash = {
        "region": "asia",
        "total_cost": "$" + asia_cost.round(2).to_s,
        "servers": asia_server
      }
    end

    minimum_cpu_output = [ west_hash, east_hash, asia_hash]
    minimum_cpu_output = minimum_cpu_output.delete_if &:empty?
    minimum_cpu_output
  end
end
