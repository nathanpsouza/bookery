require 'rails_helper'

RSpec.describe Page, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:book) }
  end
end
