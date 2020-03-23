require 'faker'

books = FactoryBot.create_list(:book, 10)

books.each do |book|
  rand(5..20).times do |page_number|
    FactoryBot.create(:page, book: book, page_number: page_number + 1)
  end
end
