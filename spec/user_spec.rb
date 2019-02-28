require 'mongoid-rspec'

RSpec.describe User do
  it {is_expected.to validate_lenght_of(:name).within(8..16)} 
end
 
