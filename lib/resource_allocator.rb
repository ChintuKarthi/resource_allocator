# frozen_string_literal: true

require 'active_record'
require 'resource_allocator/minimum_cpu.rb'

module ResourceAllocator
  include MinimumCpu
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
    # barbara wants 115 CPU for 24 Hrs.
    # here price isn't a concern. So we have to get the 115 cpus for 24hrs that's it.
    # CPU values large - 1, xlarge - 2, 2xlarge - 4, 4xlarge - 8, 8xlarge - 16, 10xlarge - 32
    # if we have 115 cpu for 24 hrs, we need to get 115 exact number.
    if(hours)
      if(cpus && price)
        puts 'Not Implemented Yet!'
      elsif(cpus)
        output_response = MinimumCpu.get_cpu_hours_cost($server_value, $region, hours, cpus)
        puts output_response
      elsif(price)
        puts 'Not Implemented Yet!'
      end
    end
  end
end
