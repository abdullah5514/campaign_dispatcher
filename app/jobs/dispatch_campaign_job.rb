class DispatchCampaignJob < ApplicationJob
  queue_as :default
  
  def perform(campaign_id)
    campaign = Campaign.find(campaign_id)
    campaign.update!(status: :processing)
    campaign.reload
    
    campaign.recipients.queued.find_each do |recipient|
      begin
        sleep(rand(1..3))
        
        if rand(100) < 10
          raise StandardError, "Simulated delivery failure"
        end
        
        recipient.update!(status: :sent)
        campaign.reload
        campaign.recipients.reload
        
        broadcast_recipient_update(recipient, campaign)
        broadcast_campaign_progress(campaign)
        
      rescue StandardError => e
        recipient.update!(
          status: :failed,
          error_message: e.message
        )
        
        campaign.reload
        campaign.recipients.reload
        
        broadcast_recipient_update(recipient, campaign)
        broadcast_campaign_progress(campaign)
      end
    end
    
    campaign.update!(status: :completed)
    campaign.reload
    campaign.recipients.reload
    broadcast_campaign_progress(campaign)
  end
  
  private
  
  def broadcast_recipient_update(recipient, campaign)
    Turbo::StreamsChannel.broadcast_replace_to(
      "campaign_#{campaign.id}_recipients",
      target: "recipient_#{recipient.id}",
      partial: "recipients/recipient",
      locals: { recipient: recipient }
    )
  end
  
  def broadcast_campaign_progress(campaign)
    ActiveRecord::Base.connection.clear_query_cache
    campaign = Campaign.find(campaign.id)
    
    Turbo::StreamsChannel.broadcast_update_to(
      "campaign_#{campaign.id}_progress",
      target: "campaign_#{campaign.id}_progress",
      partial: "campaigns/progress",
      locals: { campaign: campaign }
    )
    
    Turbo::StreamsChannel.broadcast_replace_to(
      "campaigns",
      target: "campaign_#{campaign.id}",
      partial: "campaigns/campaign",
      locals: { campaign: campaign }
    )
  end
end

