require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'slug' do
    it 'create slug when book is saved' do
      book = FactoryBot.create(:book)

      expect(book.slug).to_not be_nil
    end
  end
end
