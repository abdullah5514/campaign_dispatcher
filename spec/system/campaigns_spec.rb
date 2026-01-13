require 'rails_helper'

RSpec.describe "Campaigns", type: :system do
  include ActiveJob::TestHelper

  before do
    driven_by(:selenium_chrome_headless)
  end
  
  describe "creating a new campaign" do
    it "allows creating a campaign with recipients" do
      visit root_path
      
      click_link "New Campaign", match: :first
      
      fill_in "Title", with: "Q1 Customer Feedback"
      
      within all(".nested-fields").first do
        fill_in "Name", with: "John Doe", match: :first
        fill_in "Email", with: "john@example.com", match: :first
      end
      
      click_button "Create Campaign"
      
      expect(page).to have_content("Campaign created successfully!")
      expect(page).to have_content("Q1 Customer Feedback")
    end
  end
  
  describe "viewing campaigns list" do
    let!(:campaign1) { create(:campaign, title: "Campaign One") }
    let!(:campaign2) { create(:campaign, title: "Campaign Two") }
    
    it "displays all campaigns" do
      visit campaigns_path
      
      expect(page).to have_content("Campaign One")
      expect(page).to have_content("Campaign Two")
    end
  end
  
  describe "dispatching a campaign", :js do
    let!(:campaign) { create(:campaign, :with_recipients, title: "Test Campaign") }
    
    before do
      # Speed up the job for testing
      allow_any_instance_of(DispatchCampaignJob).to receive(:sleep).and_return(nil)
    end
    
    it "shows real-time updates when dispatching" do
      visit campaign_path(campaign)
      
      expect(page).to have_content("Test Campaign")
      expect(page).to have_content("Pending")
      
      # Use perform_enqueued_jobs to execute the job synchronously in test
      perform_enqueued_jobs do
        click_button "Dispatch Campaign"
      end
      
      # The page should show the dispatch started message
      expect(page).to have_content("Campaign dispatch started")
    end
  end
  
  describe "viewing campaign details" do
    let!(:campaign) { create(:campaign, :with_recipients, title: "Detailed Campaign") }
    
    it "displays campaign information and recipients" do
      visit campaign_path(campaign)
      
      expect(page).to have_content("Detailed Campaign")
      expect(page).to have_content("Recipients")
      
      campaign.recipients.each do |recipient|
        expect(page).to have_content(recipient.name)
        expect(page).to have_content(recipient.email)
      end
    end
  end
  
  describe "deleting a campaign" do
    let!(:campaign) { create(:campaign, title: "Campaign to Delete") }
    
    it "allows deleting a campaign", :js do
      visit campaign_path(campaign)
      
      accept_confirm do
        click_button "Delete"
      end
      
      expect(page).to have_content("Campaign deleted successfully!")
      expect(page).not_to have_content("Campaign to Delete")
    end
  end
end

