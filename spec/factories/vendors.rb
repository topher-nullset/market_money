FactoryBot.define do
  factory :vendor do
    name { Faker::Food.unique.dish }
    description { Faker::Company.bs }
    contact_name { Faker::Name.unique.name }
    contact_phone { Faker::PhoneNumber.unique.phone_number }
    credit_accepted { [true, false].sample }
  end
end