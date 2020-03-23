FactoryBot.define do
  factory :page do
    book
    content { Faker::Markdown.sandwich }
    sequence :page_number do |n|
      n
    end
  end
end
