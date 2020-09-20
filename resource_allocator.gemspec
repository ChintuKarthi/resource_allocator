Gem::Specification.new do |spec|
  spec.name = %q{resource_allocator}
  spec.version = "1.0.0"
  spec.date = %q{2020-09-19}
  spec.summary = %q{resource_allocator is a gem to allocate the optimized cpu based on the region and hours requested}
  spec.files = [
  	"lib/resource_allocator.rb",
  	"lib/resource_allocator/minimum_cpu.rb",
  	"lib/resource_allocator/maximum_price.rb",
  	"lib/resource_allocator/min_cpu_max_price.rb",
  	"lib/resource_allocator/helper/optimize_cpu.rb"
  ]
  spec.require_paths = ['lib']
  spec.author = 'Karthikeyan Dhanapal'
  spec.email = 'chintukarthi@gmail.com'
end
