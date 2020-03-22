FactoryBot.define do
  factory :page do
    book { nil }
    content { "MyText" }
    number { 1 }
  end
end
