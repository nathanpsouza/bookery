require 'rails_helper'

RSpec.describe Page, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
    it do
      page = FactoryBot.create(:page)
      expect(page).to validate_uniqueness_of(:page_number).scoped_to(:book_id)
    end

    it { is_expected.to validate_numericality_of(:page_number).is_greater_than(0) }
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:book) }
  end
end
