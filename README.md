# Resource Allocator Gem (Ruby)

The Resource Allocator is responsible for assigning servers for users based on their needs.

## Compatibility

This Gem is developed under MacOS with ruby version - 2.6.5.

This Gem assumes that ruby is already installed in the system.

## Local development

To install the Gem, first bclone it locally by using the git clone command
```
git clone https://github.com/ChintuKarthi/resource_allocator/
```
Once cloned, then follow the steps mentioned below to install the gem locally.

Step 1: cd to the cloned repo.
```
cd resource_allocator
```
Step 2: Install gem dependencies by running following command.
```
bundle install
```
This will install the required gem for our client from rubygems.org

Step 3: Run the below command to load the gem.
```
gem build resource_allocator.gemspec
```
This command loads the latest gem changes.

Step 4: Run the below command from the gem root directory to install the gem locally
```
gem install ./resource_allocator-1.0.0.gem
```
Now the Gem is installed in your local successfully.


## Accessing Resource Allocator Gem

To Access the client, go to the terminal(Mac) and run the following command to access the irb
```
irb
```
From here, we need to require the Gem to use start using it's features. It can be done by running the below command
```
require 'resource_allocator'
```

Our Resource Allocator End point is the below one
```
ResourceAllocator.get_costs(hours, cpus, price)
```
1. To get the minimum cpu, provide only cpus and hours and zero for price
```
(e.g) ResourceAllocator.get_costs(24, 115, 0)
```
2. To get the maximum cost, provide only maximum cost and hours and zero for cpus
```
(e.g) ResourceAllocator.get_costs(8, 0, 45)
```
3. To get the minimum cpu and maximum cost followed up hours provide all of the values.
```
(e.g) ResourceAllocator.get_costs(8, 50, 100)
```

# Test Cases
  The gem 'rspec' handles all the test cases written under the spec folder.
  To run the test cases, run the following command from the root directory of the gem.
  ```
    rspec spec
  ```
  This command will trigger all the test cases under the spec folder.
