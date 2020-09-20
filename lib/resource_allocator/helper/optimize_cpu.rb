# frozen_string_literal: true

module OptimizeCPU

  # This method is the core algorithm to optimize the number of servers based on the user requested cpus
  # It takes the servers and the targetServerSize as an input.
  # Gives back an array of optimized servers for the given CPU count.
  def self.optimize_servers(servers, targetServerSize, server_value)
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
    result.each{|key| optimized_servers_hash[$server_value[key]] += 1}
    optimized_servers_hash
  end
end
