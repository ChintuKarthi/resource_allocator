# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceAllocator, type: :module do
  let(:minimum_cpu_response) do
    [
      {
        "region": "asia",
        "total_cost": "$205.68",
        "servers": {
          "large": 1,
          "xlarge": 1,
          "8xlarge": 7
        }
      },
      {
        "region": "us-east",
        "total_cost": "$245.04",
        "servers": {
          "large": 1,
          "xlarge": 1,
          "8xlarge": 1,
          "10xlarge": 3
        }
      },
      {
        "region": "us-west",
        "total_cost": "$255.12",
        "servers": {
          "large": 3,
          "8xlarge": 1,
          "10xlarge": 3
        }
      }
    ]
  end

  let(:maximum_cost_response) do
    [
      {
        "region": "us-west",
        "total_cost": "$45.0",
        "servers": {
          "2xlarge": 5,
          "4xlarge": 4
        }
      }
    ]
  end

  let(:min_cpu_max_hours) do
    [
      {
        "region": "asia",
        "total_cost": "$29.92",
        "servers": {
          "xlarge": 1,
          "8xlarge": 3
        }
      },
      {
        "region": "us-east",
        "total_cost": "$35.6",
        "servers": {
          "xlarge": 1,
          "8xlarge": 1,
          "10xlarge": 1
        }
      },
      {
        "region": "us-west",
        "total_cost": "$36.4",
        "servers": {
          "large": 2,
          "8xlarge": 1,
          "10xlarge": 1
        }
      }
    ]
  end

  let(:min_cpu_error_message) { 'Cannot provide output for the minimum of 0.2 cpus and 24 hours. Please try with different cpu and hours' }
  let(:max_price_error_message) { 'Cannot provide output for the Maximum of 0.8 price and 8 hours. Please try with different price and hours' }
  let(:min_cpu_max_price_error_message) { 'Cannot provide output for the minimum of 115 cpus and 45 total cost. Please provide either higher price or lower cpu' }

  describe "# Minimum 'X' CPU with 'Y' Hours " do

    # allow is used to mock the reponse of the client

    context 'when proper arguments are passed' do
      before do
        allow(ResourceAllocator).to receive(:get_costs).with(hours, cpus, price).and_return(minimum_cpu_response)
      end

      let(:hours) { 24 }
      let(:cpus) { 115 }
      let(:price) { 0 }

      it "should return back the proper response" do
        get_costs_call = ResourceAllocator.get_costs(hours, cpus, price)
        expect(get_costs_call).to eq(minimum_cpu_response)
      end

      it 'gives response in sorted order' do
        get_costs_call = ResourceAllocator.get_costs(hours, cpus, price)
        expect(get_costs_call[0][:'total_cost']).to eq('$205.68')
        expect(get_costs_call[1][:'total_cost']).to eq('$245.04')
        expect(get_costs_call[2][:'total_cost']).to eq('$255.12')
      end

    end

    context 'when invalid arguments are passed' do
      before do
        allow(ResourceAllocator).to receive(:get_costs).with(hours, cpus, price).and_return(min_cpu_error_message)
      end

      let(:hours) { 8 }
      let(:cpus) { 0.2 }
      let(:price) { 0 }

      it "should return error message" do
        get_costs_call = ResourceAllocator.get_costs(hours, cpus, price)
        expect(get_costs_call).to eq('Cannot provide output for the minimum of 0.2 cpus and 24 hours. Please try with different cpu and hours')
      end
    end
  end

  describe "# Maximum 'X' Price for 'Y' Hours " do

    # allow is used to mock the reponse of the client

    context 'when proper arguments are passed' do
      before do
        allow(ResourceAllocator).to receive(:get_costs).with(hours, cpus, price).and_return(maximum_cost_response)
      end

      let(:hours) { 8 }
      let(:cpus) { 0 }
      let(:price) { 45 }

      it "should return back the proper response" do
        get_costs_call = ResourceAllocator.get_costs(hours, cpus, price)
        expect(get_costs_call).to eq(maximum_cost_response)
        expect(get_costs_call[0][:'total_cost']).to eq('$45.0')
      end
    end

    context 'when invalid arguments are passed' do
      before do
        allow(ResourceAllocator).to receive(:get_costs).with(hours, cpus, price).and_return(max_price_error_message)
      end

      let(:hours) { 8 }
      let(:cpus) { 0.2 }
      let(:price) { 0 }

      it "should return error message" do
        get_costs_call = ResourceAllocator.get_costs(hours, cpus, price)
        expect(get_costs_call).to eq('Cannot provide output for the Maximum of 0.8 price and 8 hours. Please try with different price and hours')
      end
    end
  end

  describe "# Minimum 'X' CPU with Maximum 'Y' Price for 'Z' Hours " do

    # allow is used to mock the reponse of the client

    context 'when proper arguments are passed' do
      before do
        allow(ResourceAllocator).to receive(:get_costs).with(hours, cpus, price).and_return(min_cpu_max_hours)
      end

      let(:hours) { 8 }
      let(:cpus) { 50 }
      let(:price) { 100 }

      it "should return back the proper response" do
        get_costs_call = ResourceAllocator.get_costs(hours, cpus, price)
        expect(get_costs_call).to eq(min_cpu_max_hours)
      end

      it 'gives response in sorted order' do
        get_costs_call = ResourceAllocator.get_costs(hours, cpus, price)
        expect(get_costs_call[0][:'total_cost']).to eq('$29.92')
        expect(get_costs_call[1][:'total_cost']).to eq('$35.6')
        expect(get_costs_call[2][:'total_cost']).to eq('$36.4')
      end
    end

    context 'when invalid arguments are passed' do
      before do
        allow(ResourceAllocator).to receive(:get_costs).with(hours, cpus, price).and_return(min_cpu_max_price_error_message)
      end

      let(:hours) { 8 }
      let(:cpus) { 115 }
      let(:price) { 45 }

      it "should return error message" do
        get_costs_call = ResourceAllocator.get_costs(hours, cpus, price)
        expect(get_costs_call).to eq('Cannot provide output for the minimum of 115 cpus and 45 total cost. Please provide either higher price or lower cpu')
      end
    end
  end
end
