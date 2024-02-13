class DonationsController < ApplicationController
  def index
    @donations = Donation.all
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
      params.require(:donation).permit(:donor_name, :amount, :donation_date)
    end
end
