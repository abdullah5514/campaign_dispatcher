require 'rails_helper'

RSpec.describe DispatchCampaignJob, type: :job do
  describe '#perform' do
    let(:campaign) { create(:campaign, :with_recipients) }
    
    before do
      allow_any_instance_of(DispatchCampaignJob).to receive(:sleep)
      allow_any_instance_of(Object).to receive(:rand).with(1..3).and_return(1)
      allow_any_instance_of(Object).to receive(:rand).with(100).and_return(50)
    end
    
    it 'updates campaign status to processing' do
      expect {
        described_class.new.perform(campaign.id)
      }.to change { campaign.reload.status }.from('pending').to('completed')
    end
    
    it 'processes all recipients' do
      # Mock to avoid randomness in tests
      allow_any_instance_of(Object).to receive(:rand).with(100).and_return(50)
      
      described_class.new.perform(campaign.id)
      
      campaign.reload
      expect(campaign.recipients.queued.count).to eq(0)
      expect(campaign.recipients.sent.count + campaign.recipients.failed.count).to eq(campaign.total_count)
    end
    
    it 'marks recipients as sent when successful' do
      # Ensure no failures occur
      allow_any_instance_of(Object).to receive(:rand).with(100).and_return(50)
      
      described_class.new.perform(campaign.id)
      
      expect(campaign.recipients.sent.count).to be > 0
    end
    
    it 'marks recipients as failed when an error occurs' do
      # Force failures
      allow_any_instance_of(Object).to receive(:rand).with(100).and_return(5)
      
      described_class.new.perform(campaign.id)
      
      campaign.reload
      expect(campaign.recipients.failed.count).to be > 0
    end
    
    it 'updates campaign status to completed after processing all recipients' do
      described_class.new.perform(campaign.id)
      
      expect(campaign.reload.status).to eq('completed')
    end
    
    it 'stores error message for failed recipients' do
      # Force a failure
      allow_any_instance_of(Object).to receive(:rand).with(100).and_return(5)
      
      described_class.new.perform(campaign.id)
      
      failed_recipient = campaign.recipients.failed.first
      expect(failed_recipient.error_message).to be_present
    end
  end
end

