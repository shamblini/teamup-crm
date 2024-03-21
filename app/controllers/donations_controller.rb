class DonationsController < ApplicationController
  before_action :set_donation, only: %i[ show edit update destroy ]

  def index
    @navbar_partial = current_user.user_type.downcase == "admin" ? 'shared/header' : 'shared/header_staff'
    @donations = Donation.all
    if params[:sort]
      column = params[:sort]
      direction = params[:direction] == 'asc' ? 'desc' : 'asc'
      @donations = @donations.order("#{column} #{direction}")
    end
    if params[:search]
      search_donations
    end
    if params[:campaign]
      search_campaigns
    end
  end

  def search_campaigns
    @donations = Donation.all
    @donations = @donations.select{ |donation| donation.campaign && donation.campaign.name.include?(params[:campaign]) }

    if @donations.empty? || (params[:campaign]).empty?
      if params[:campaign]!=""
        flash[:notice] = "No donations found for campaign '#{params[:campaign]}'."
      end
      @donations = Donation.all
      redirect_to donations_path
    end\
  end

  def search_donations
    @donations = Donation.all
    @donation = @donations.find { |donation| donation.donor_name.include?(params[:search]) }
    
    if @donation
      redirect_to donation_path(@donation)
    else
      flash[:notice] = "No donation found with the donor name '#{params[:search]}'."
      redirect_to donations_path
    end
  end

  require 'csv'
  def upload_csv
    uploaded_file = params[:csv_file]
    
    begin
      CSV.foreach(uploaded_file.path, headers: true) do |row|
        donation_data = row.to_h
        Donation.create!(donation_data)
      end
      flash[:success] = "CSV file uploaded successfully."
    rescue StandardError => e
      flash[:error] = "Error uploading CSV file: #{e.message}"
    end
    
    redirect_to donations_path
  end

  def show
    @donation = Donation.find(params[:id])
  end

  def new
    @donation = Donation.new
  end

  def create
    @donation = Donation.new(donation_params)

    respond_to do |format|
      if @donation.save
        @donation.user.calculate_total_donations
        @donation.user.group.calculate_total_donations
        format.html { redirect_to donations_url, notice: "Donation was successfully created." }
        format.json { render :show, status: :created, location: @donation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @donation = Donation.find(params[:id])
  end
  
  def update
    @donation = Donation.find(params[:id])
    respond_to do |format|
      if @donation.update(donation_params)
        format.html { redirect_to donations_url, notice: "Donation was successfully updated." }
        format.json { render :show, status: :ok, location: @donation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end
  

  def delete
    @donation = Donation.find(params[:id])
  end

  def destroy
    @donation = Donation.find(params[:id])
    @donation.destroy
    respond_to do |format|
      format.html { redirect_to donations_url, notice: 'Donation was successfully deleted.' }
      format.json { head :no_content }
    end
  end
  
  private
    def set_donation
      @donation = Donation.find(params[:id])
    end

    def donation_params
      params.require(:donation).permit(:amount, :donation_date, :campaign_id, :user_id)
    end
  
end
