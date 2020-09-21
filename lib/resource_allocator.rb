# frozen_string_literal: true

require 'active_record'
require 'resource_allocator/minimum_cpu.rb'
require 'resource_allocator/maximum_price.rb'
require 'resource_allocator/min_cpu_max_price.rb'
require 'json'

module ResourceAllocator
  include MinimumCpu
  include MaximumPrice
  include MinCpuMaxPrice
  $server_value = {
    1 => 'large',
    2 => 'xlarge',
    4 => '2xlarge',
    8 => '4xlarge',
    16 => '8xlarge',
    32 => '10xlarge'
  }

  $region = {
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

  # get_costs method gets the cost based on the inputs provided.
  # hours - no of hours needed
  # cpus - minimum no of cpus required
  # price - maximum price user willing to pay.
  def self.get_costs(hours, cpus, price)
    # Sample input requests
    # Barbara wants 115 CPU for 24 Hrs.
    # Here price isn't a concern. So we have to get the 115 cpus for 24hrs that's it.
    # CPU values large - 1, xlarge - 2, 2xlarge - 4, 4xlarge - 8, 8xlarge - 16, 10xlarge - 32
    # if we have 115 cpu for 24 hrs, we need to get 115 exact number.
    if(hours)
      if(!(cpus.zero? || cpus.nil?) && !(price.zero? || price.nil?))
        output_response = MinCpuMaxPrice.get_min_cpu_max_price($server_value, $region, hours, cpus, price)
        if output_response.present?
          # sorting by total cost
          output_response = output_response.sort_by{ |hash| hash[:'total_cost'] }
          print "\n For the minimum of " ,cpus, " cpus and maximum cost of ", price, " total cost, the optimized servers are:\n"
          puts "\n--------------------------------------------------"
          puts JSON.pretty_generate(output_response)
          puts "\n--------------------------------------------------"
        else
          print "\n Cannot provide output for the minimum of " ,cpus, " cpus and ", price, " total cost. Please provide either higher price or lower cpu"
        end
      elsif(!(cpus.zero?) && !(price.zero? && price.nil?))
        output_response = MinimumCpu.get_cpu_hours_cost($server_value, $region, hours, cpus)
        if output_response.present?
          # sorting by total cost
          output_response = output_response.sort_by{ |hash| hash[:'total_cost'] }
          print "\n For the minimum of " ,cpus, " cpus and ", hours, "hours, the optimized servers are:\n"
          puts "\n--------------------------------------------------"
          puts JSON.pretty_generate(output_response)
          puts "\n--------------------------------------------------"
        else
          print "\n Cannot provide output for the minimum of " ,cpus, " cpus and ", hours, " hours. Please try with different cpu and hours"
        end
      elsif(price && !(cpus.zero? && cpus.nil?))
        output_response = MaximumPrice.get_price_hours_cost($region, hours, price)
        if output_response.present?
          # sorting by total cost
          output_response = output_response.sort_by{ |hash| hash[:'total_cost'] }
          print "\n For the price of $" ,price, " and ", hours, "hours, the optimized servers are:\n"
          puts "\n--------------------------------------------------"
          puts JSON.pretty_generate(output_response)
          puts "\n--------------------------------------------------"
        else
          print "\n Cannot provide output for the Maximum of " ,price, " price and ", hours, " hours. Please try with different price and hours"
        end
      end
    end
  end
end
