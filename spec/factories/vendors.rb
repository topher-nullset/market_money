FactoryBot.define do
  factory :vendor do
    name { Faker::Food.unique.dish }
    description { Faker::Company.bs }
    contact_name { Faker::Name.unique.name }
    contact_phone { Faker::PhoneNumber.unique.phone_number }
    credit_accepted { [true, false].sample }

    trait :with_market do
      after(:create) do |vendor|
        market = create(:market) # You can also replace this with find_or_create if needed
        vendor.markets << market
      end
    end
  end
end