FactoryBot.define do
  factory :market do
    name { Faker::Company.unique.buzzword }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    county { Faker::Adjective.positive}
    state { Faker::Address.state }
    zip { Faker::Address.zip }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }

    trait :with_vendor do
      after(:create) do |market|
        create_list(:market_vendor, 3, market: market)
      end
    end
  end
end