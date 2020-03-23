class Page < ApplicationRecord
  belongs_to :book

  validates :content, presence: true
  validates :page_number, numericality: { greater_than: 0 }, uniqueness: { scope: :book_id }
end
