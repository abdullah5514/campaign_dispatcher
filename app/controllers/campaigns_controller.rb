class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:show, :edit, :update, :destroy, :dispatch_campaign]
  
  def index
    @campaigns = Campaign.order(created_at: :desc)
  end
  
  def show
    @recipients = @campaign.recipients.order(created_at: :asc)
  end
  
  def new
    @campaign = Campaign.new
    5.times { @campaign.recipients.build }
  end
  
  def create
    @campaign = Campaign.new(campaign_params)
    
    if @campaign.save
      redirect_to @campaign, notice: "Campaign created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @campaign.update(campaign_params)
      redirect_to @campaign, notice: "Campaign updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @campaign.destroy
    redirect_to campaigns_url, notice: "Campaign deleted successfully!"
  end
  
  def dispatch_campaign
    if @campaign.pending?
      DispatchCampaignJob.perform_later(@campaign.id)
      redirect_to @campaign, notice: "Campaign dispatch started! Watch the progress below."
    else
      redirect_to @campaign, alert: "Campaign has already been dispatched."
    end
  end
  
  private
  
  def set_campaign
    @campaign = Campaign.find(params[:id])
  end
  
  def campaign_params
    params.require(:campaign).permit(
      :title,
      recipients_attributes: [:id, :name, :email, :_destroy]
    )
  end
end

