require 'rails_helper'

RSpec.describe Campaign, type: :model do
  describe 'associations' do
    it { should have_many(:recipients).dependent(:destroy) }
  end
  
  describe 'validations' do
    it { should validate_presence_of(:title) }
  end
  
  describe 'nested attributes' do
    it 'accepts nested attributes for recipients' do
      campaign = Campaign.new(
        title: 'Test Campaign',
        recipients_attributes: [
          { name: 'John Doe', email: 'john@example.com' },
          { name: 'Jane Smith', email: 'jane@example.com' }
        ]
      )
      
      expect(campaign.save).to be true
      expect(campaign.recipients.count).to eq(2)
    end
  end
  
  describe 'enums' do
    it 'defines status enum' do
      should define_enum_for(:status)
        .with_values(pending: 0, processing: 1, completed: 2)
    end
  end
  
  describe '#sent_count' do
    it 'returns the count of sent recipients' do
      campaign = create(:campaign)
      create_list(:recipient, 3, :sent, campaign: campaign)
      create_list(:recipient, 2, :queued, campaign: campaign)
      
      expect(campaign.sent_count).to eq(3)
    end
  end
  
  describe '#failed_count' do
    it 'returns the count of failed recipients' do
      campaign = create(:campaign)
      create_list(:recipient, 2, :failed, campaign: campaign)
      create_list(:recipient, 3, :queued, campaign: campaign)
      
      expect(campaign.failed_count).to eq(2)
    end
  end
  
  describe '#queued_count' do
    it 'returns the count of queued recipients' do
      campaign = create(:campaign)
      create_list(:recipient, 4, :queued, campaign: campaign)
      create_list(:recipient, 1, :sent, campaign: campaign)
      
      expect(campaign.queued_count).to eq(4)
    end
  end
  
  describe '#total_count' do
    it 'returns the total count of recipients' do
      campaign = create(:campaign)
      create_list(:recipient, 5, campaign: campaign)
      
      expect(campaign.total_count).to eq(5)
    end
  end
  
  describe '#progress_percentage' do
    it 'returns 0 when there are no recipients' do
      campaign = create(:campaign)
      expect(campaign.progress_percentage).to eq(0)
    end
    
    it 'calculates the progress percentage correctly' do
      campaign = create(:campaign)
      create_list(:recipient, 3, :sent, campaign: campaign)
      create_list(:recipient, 1, :failed, campaign: campaign)
      create_list(:recipient, 6, :queued, campaign: campaign)
      
      # (3 sent + 1 failed) / 10 total = 40%
      expect(campaign.progress_percentage).to eq(40)
    end
    
    it 'returns 100 when all recipients are processed' do
      campaign = create(:campaign)
      create_list(:recipient, 5, :sent, campaign: campaign)
      
      expect(campaign.progress_percentage).to eq(100)
    end
  end
  
  describe '#status_badge_class' do
    it 'returns the correct class for pending status' do
      campaign = create(:campaign, status: :pending)
      expect(campaign.status_badge_class).to eq('bg-yellow-100 text-yellow-800')
    end
    
    it 'returns the correct class for processing status' do
      campaign = create(:campaign, status: :processing)
      expect(campaign.status_badge_class).to eq('bg-blue-100 text-blue-800')
    end
    
    it 'returns the correct class for completed status' do
      campaign = create(:campaign, status: :completed)
      expect(campaign.status_badge_class).to eq('bg-green-100 text-green-800')
    end
  end
end

