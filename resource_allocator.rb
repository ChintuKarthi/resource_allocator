def get_costs(hours, cpus, price)
  region = {
    'us-east': {
      'large': 0.12,
      'xlarge': 0.23,
      '2xlarge': 0.45,
      '4xlarge': 0.774,
      '8xlarge': 1.4,
      '10xlarge': 2.82
    },
    'us-west': {
      'large': 0.14,
      '2xlarge': 0.413,
      '4xlarge': 0.89,
      '8xlarge': 1.3,
      '10xlarge': 2.97
    },
    'asia': {
      'large': 0.11,
      'xlarge': 0.20,
      '4xlarge': 0.67,
      '8xlarge': 1.18
    }
  }

  east_servers = [1,2,4,8,16,32]
  west_servers = [1,4,8,16,32]
  asia_servers = [1,2,8,16]


  # barbara wants 115 CPU for 24 Hrs.

  # here price isn't a concern. So we have to get the 115 cpus for 24hrs that's it.

  # CPU values large - 1, xlarge - 2, 2xlarge - 4, 4xlarge - 8, 8xlarge - 16, 10xlarge - 32

  # if we have 115 cpu for 24 hrs, we need to get 115 exact number.

  if(hours)

    if(cpus && price)
    end
    elsif(cpus)
      # cpus = 115, hours = 24
      # if cpus is main thing first calculate the split for the given count and then perform the calculation based on the size and return back the response (region wise).

      east_optimized_servers = optimize_servers(east_servers, cpus);
      west_optimized_servers = optimize_servers(west_servers, cpus);
      asia_optimized_servers = optimize_servers(west_servers, cpus);


      # getting total cost for the optimized server we formed

      east_total_cost = get_total_cost(east_optimized_servers, region['us-east'])
      west_total_cost = get_total_cost(west_optimized_servers, region['us-west'])
      asia_total_cost = get_total_cost(asia_optimized_servers, region['asia'])

      final_region = {
        'us-east' : east_region,
        'us-west' : west_region,
        'asia' : asia_region
      }
    end

    elsif(price)
    end 
  end
end


# This method will optimize the servers based on the cpus requested and will give back the hash of servers with optimized count
# servers - array of servers in the specifed region
# targetServerSize - user input server size

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
  result.each{|key| optimized_servers_hash[key] += 1}

  puts optimized_servers_hash
end


# Based on the optimized server in the given region, it will give back the total cost
def get_total_cost(optimized_servers, region_cost)
  # TO DO
end

def user_request
  hours = 15
  cpus = 115
  price = 95
  final_output = get_costs(hours, cpus, price)
  print final_output
end
