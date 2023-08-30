FactoryBot.define do
  factory :market do
    name { 'Test Market' }
    street { '123 Test Street' }
    city { 'Test City' }
    county { 'Test County' }
    state { 'Test State' }
    zip { '12345' }
    lat { '12.3456789' }
    lon { '-98.7654321' }
  end
end