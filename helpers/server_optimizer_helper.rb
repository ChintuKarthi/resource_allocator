# frozen_string_literal: true

module ServerOptimizerHelper
  def cpus_hours(cpus, hours, region)
    # This method is the core algorithm to optimize the number of servers based on the user requested cpus
    # It takes the servers and the targetServerSize as an input.
    # Gives back an array of optimized servers for the given CPU count.
    def optimize_servers(servers, targetServerSize)
      n = servers.length()
      count = Array.new(targetServerSize+1, 0)
      from = Array.new(targetServerSize+1, 0)
      count[0] = 1
      targetServerSize.times do |i|
        if count[i] > 0
          n.times do |j|
            m = i + servers[j]
            if m <= targetServerSize
              if (count[m] == 0 || count[m] > count[i] + 1)
                count[m] = count[i] + 1;
                from[m] = j;
              end
            end
          end
        end
      end

      if (count[targetServerSize] == 0)
        nil
      end

      result = Array.new((count[targetServerSize] - 1), 0)
      k = targetServerSize;

      while k > 0 do
        result[count[k] - 2] = servers[from[k]];
        k = k - servers[from[k]];
      end
      optimized_servers_hash = Hash.new(0)
      result.each{|key| optimized_servers_hash[SERVER_VALUE[key]] += 1}
      optimized_servers_hash
    end

    # This method takes the server_keys (region specific server size) as a input.
    # Return an array of their equivalent numeric values by comparing it with SERVER_VALUE
    def get_server_type(server_keys)
      server_array = Array.new()
      server_keys.each_with_index do |k, index|
        server_array[index] = SERVER_VALUE.invert[k.to_s]
      end
      server_array
    end

    # This method takes optimized servers and returns their total cost
    # Calculation based on the region, cost per hour and no of hours.
    # cost - An Array of region specific cost values
    # server - Optimized servers values
    # hours - total no of hours expected to run
    def get_region_cost(server, cost, hours)
      server_cost = 0
      server.each do|key, value|
        if cost[key].present?
          server_cost = server_cost + (cost[key] * value * hours)
        end
      end
      server_cost
    end


    east_keys = get_server_type(region[:'us-east'].stringify_keys.keys)
    west_keys = get_server_type(region[:'us-west'].stringify_keys.keys)
    asia_keys = get_server_type(region[:'asia'].stringify_keys.keys)

    east_server = optimize_servers(east_keys, cpus)
    west_server = optimize_servers(west_keys, cpus)
    asia_server = optimize_servers(asia_keys, cpus)


    east_cost = get_region_cost(east_server, region[:'us-east'].stringify_keys, hours)
    west_cost = get_region_cost(west_server, region[:'us-west'].stringify_keys, hours)
    asia_cost = get_region_cost(asia_server, region[:'asia'].stringify_keys, hours)

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
