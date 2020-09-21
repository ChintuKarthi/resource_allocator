# frozen_string_literal: true

require 'active_record'
require 'resource_allocator/minimum_cpu.rb'

module MinCpuMaxPrice
  include MinimumCpu
  # This method returns a JSON Response for minimum 'X' cpus for 'Y' hours with maximum price of 'Z' total cost
  def self.get_min_cpu_max_price(server_value, region, hours, cpus, price)
    # This method calls the minimum cpu module to get the minimum possible cpu's
    minimum_cpu_hash = MinimumCpu.get_cpu_hours_cost(server_value, region, hours, cpus)
    min_cpu_max_price_output = []
    if minimum_cpu_hash.present?
      minimum_cpu_hash.each do|current_region|
        current_total_cost = current_region[:total_cost]
        # To remove the $ symbol from the front of total cost
        current_total_cost[0] = ''
        # If the cost is less than or equal to price add it to the output response
        if(current_total_cost.to_f <= price)
          # Adding back the dollar symbol
          current_region[:total_cost] = "$" + current_region[:total_cost]
          min_cpu_max_price_output = min_cpu_max_price_output.append(current_region)
        end
      end
    end
    min_cpu_max_price_output
  end
end
