require 'rails_helper'

RSpec.describe "Campaigns", type: :request do
  describe "GET /campaigns" do
    it "returns http success" do
      get campaigns_path
      expect(response).to have_http_status(:success)
    end
    
    it "displays all campaigns" do
      create_list(:campaign, 3)
      get campaigns_path
      expect(response.body).to include("Campaigns")
    end
  end
  
  describe "GET /campaigns/:id" do
    let(:campaign) { create(:campaign, :with_recipients) }
    
    it "returns http success" do
      get campaign_path(campaign)
      expect(response).to have_http_status(:success)
    end
    
    it "displays campaign details" do
      get campaign_path(campaign)
      expect(response.body).to include(campaign.title)
    end
  end
  
  describe "GET /campaigns/new" do
    it "returns http success" do
      get new_campaign_path
      expect(response).to have_http_status(:success)
    end
  end
  
  describe "POST /campaigns" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          campaign: {
            title: "New Campaign",
            recipients_attributes: [
              { name: "John Doe", email: "john@example.com" },
              { name: "Jane Smith", email: "jane@example.com" }
            ]
          }
        }
      end
      
      it "creates a new campaign" do
        expect {
          post campaigns_path, params: valid_params
        }.to change(Campaign, :count).by(1)
      end
      
      it "creates recipients" do
        expect {
          post campaigns_path, params: valid_params
        }.to change(Recipient, :count).by(2)
      end
      
      it "redirects to the campaign show page" do
        post campaigns_path, params: valid_params
        expect(response).to redirect_to(campaign_path(Campaign.last))
      end
    end
    
    context "with invalid parameters" do
      let(:invalid_params) do
        {
          campaign: {
            title: "",
            recipients_attributes: []
          }
        }
      end
      
      it "does not create a campaign" do
        expect {
          post campaigns_path, params: invalid_params
        }.not_to change(Campaign, :count)
      end
      
      it "renders the new template with unprocessable entity status" do
        post campaigns_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  
  describe "POST /campaigns/:id/dispatch" do
    let(:campaign) { create(:campaign, :with_recipients) }
    
    it "enqueues a DispatchCampaignJob" do
      expect {
        post dispatch_campaign_campaign_path(campaign)
      }.to have_enqueued_job(DispatchCampaignJob).with(campaign.id)
    end
    
    it "redirects to the campaign show page" do
      post dispatch_campaign_campaign_path(campaign)
      expect(response).to redirect_to(campaign_path(campaign))
    end
    
    context "when campaign is not pending" do
      let(:completed_campaign) { create(:campaign, :completed, :with_recipients) }
      
      it "does not enqueue a job" do
        expect {
          post dispatch_campaign_campaign_path(completed_campaign)
        }.not_to have_enqueued_job(DispatchCampaignJob)
      end
    end
  end
  
  describe "DELETE /campaigns/:id" do
    let!(:campaign) { create(:campaign) }
    
    it "deletes the campaign" do
      expect {
        delete campaign_path(campaign)
      }.to change(Campaign, :count).by(-1)
    end
    
    it "redirects to campaigns index" do
      delete campaign_path(campaign)
      expect(response).to redirect_to(campaigns_path)
    end
  end
end

