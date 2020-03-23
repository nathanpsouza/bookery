FactoryBot.define do
  factory :book do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraphs.join(' ') }
  end
end
