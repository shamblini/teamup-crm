class CampaignsController < ApplicationController
  before_action :set_campaign, only: %i[ show edit update destroy ]
  def index
    @navbar_partial = current_user.user_type.downcase == "admin" ? 'shared/header' : 'shared/header_staff'
    @campaigns = Campaign.all
    if params[:sort]
      column = params[:sort]
      direction = params[:direction] == 'asc' ? 'desc' : 'asc'
      @campaigns = @campaigns.order("#{column} #{direction}")
    end
    if params[:search]
      search_campaigns
    end
  end

  require 'csv'
  def upload_csv
    uploaded_file = params[:csv_file]
    
    begin
      CSV.foreach(uploaded_file.path, headers: true) do |row|
        campaign_data = row.to_h
        Campaign.create!(campaign_data)
      end
      flash[:success] = "CSV file uploaded successfully."
    rescue StandardError => e
      flash[:error] = "Error uploading CSV file: #{e.message}"
    end
    
    redirect_to donations_path
  end

  def search_campaigns
    @campaigns = Campaign.all
    @campaign = @campaigns.find { |campaign| campaign.name.include?(params[:search]) }
    
    if @campaign
      redirect_to campaign_path(@campaign)
    else
      if params[:search]!=""
        flash[:notice] = "No campaign found with the name '#{params[:search]}'."
      end
      redirect_to campaigns_path
    end
  end

  def show
    @campaign = Campaign.find(params[:id])
    @donations = Donation.all
    @donations = @donations.select{ |donation| donation.campaign && donation.campaign.name.include?(@campaign.name) }
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(campaign_params)

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to campaigns_url, notice: "Campaign was successfully created." }
        format.json { render :show, status: :created, location: @campaign }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @campaign = Campaign.find(params[:id])
  end

  def update
    @campaign = Campaign.find(params[:id])
    if @campaign.update(campaign_params)
      redirect_to @campaign
    else
      render 'edit'
    end
  end

  def delete
    @campaign = Campaign.find(params[:id])
  end

  def destroy
    @campaign = Campaign.find(params[:id])
    @campaign.destroy
    redirect_to campaigns_path
  end

  private
  def set_campaign
    @campaign = Campaign.find(params[:id])
  end

  def campaign_params
    params.require(:campaign).permit(:name, :goal_amount, :start_date, :end_date. :group)
  end
end
