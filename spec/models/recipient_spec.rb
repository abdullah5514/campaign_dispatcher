require 'rails_helper'

RSpec.describe Recipient, type: :model do
  describe 'associations' do
    it { should belong_to(:campaign) }
  end
  
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    
    it 'validates email format' do
      recipient = build(:recipient, email: 'invalid_email')
      expect(recipient).not_to be_valid
      expect(recipient.errors[:email]).to include('is invalid')
    end
    
    it 'accepts valid email format' do
      recipient = build(:recipient, email: 'valid@example.com')
      expect(recipient).to be_valid
    end
  end
  
  describe 'enums' do
    it 'defines status enum' do
      should define_enum_for(:status)
        .with_values(queued: 0, sent: 1, failed: 2)
    end
  end
  
  describe '#status_badge_class' do
    it 'returns the correct class for queued status' do
      recipient = create(:recipient, status: :queued)
      expect(recipient.status_badge_class).to eq('bg-gray-100 text-gray-800')
    end
    
    it 'returns the correct class for sent status' do
      recipient = create(:recipient, status: :sent)
      expect(recipient.status_badge_class).to eq('bg-green-100 text-green-800')
    end
    
    it 'returns the correct class for failed status' do
      recipient = create(:recipient, status: :failed)
      expect(recipient.status_badge_class).to eq('bg-red-100 text-red-800')
    end
  end
end

