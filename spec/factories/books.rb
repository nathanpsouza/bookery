FactoryBot.define do
  factory :book do
    transient do
      total_pages { 0 }
    end

    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraphs.join(' ') }

    after(:create) do |book, evaluator|
      FactoryBot.create_list(:page, evaluator.total_pages, book: book) if evaluator.total_pages > 0
    end
  end
end
