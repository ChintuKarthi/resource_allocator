# frozen_string_literal: true

module OptimizeCPU

  # This method is the core algorithm to optimize the number of servers based on the user requested cpus
  # It takes the servers and the targetServerSize as an input.
  # Gives back an array of optimized servers for the given CPU count.
  # call_flag is to identify from which module the optimize_servers method is called.
  # 0 - MinimumCpu, 1 - MaximumPrice
  def self.optimize_servers(servers, targetServerSize, compare_value, call_flag)
    n = servers.length()
    targetServerSize = targetServerSize.to_i
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

    # return nil if no possible combination is available
    if count[targetServerSize] == 0
      return nil
    end

    result = Array.new((count[targetServerSize] - 1), 0)
    k = targetServerSize;

    while k > 0 do
      result[count[k] - 2] = servers[from[k]];
      k = k - servers[from[k]];
    end

    optimized_servers_hash = Hash.new(0)
    if call_flag == 0
      result.each{|key| optimized_servers_hash[compare_value[key]] += 1}
    elsif call_flag == 1
      result.each{|key| optimized_servers_hash[compare_value[((key.to_f)/10000)]] += 1}
    end
    optimized_servers_hash
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
end
