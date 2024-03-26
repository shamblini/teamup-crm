class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show edit update destroy ]

  # GET /groups or /groups.json
  def index
    @navbar_partial = current_user.user_type.downcase == "admin" ? 'shared/header' : 'shared/header_staff'

    if current_user.user_type.downcase != "admin"
      redirect_to group_path(current_user.group)
    end

    @groups = Group.all
    @groups = @groups.where(org_type: params[:org_type]) if params[:org_type].present?
    @groups = @groups.where("name LIKE ?", "%#{params[:search]}%") if params[:search].present?
    if params[:sort]
      column = params[:sort]
      direction = params[:direction] == 'asc' ? 'desc' : 'asc'
      @groups = @groups.order("#{column} #{direction}")
    end
  end

  # GET /groups/1 or /groups/1.json
  def show
    @navbar_partial = current_user.user_type.downcase == "admin" ? 'shared/header' : 'shared/header_staff'

    if current_user.user_type.downcase != "admin" && current_user.group != @group
      flash[:alert] = "You do not have permission to view a different group."
      redirect_to group_path(current_user.group)
    end

    @group = Group.find(params[:id])
    @users = @group.users.includes(:donations).map { |user| user.attributes.merge(total_donations: user.calculate_total_donations) }
  end

  def list_users
    @group = Group.find(params[:id])

    if current_user.user_type.downcase != "admin" && current_user.group != @group
      flash[:alert] = "You do not have permission to view a different group."
      redirect_to group_path(current_user.group)
    end

    @users = @group.users
    if params[:sort]
      column = params[:sort]
      direction = params[:direction] == 'asc' ? 'desc' : 'asc'
      @users = @users.order("#{column} #{direction}")
    end
  end
  
  def donation_history
    @group = Group.find(params[:id])

    if current_user.user_type.downcase != "admin" && current_user.group != @group
      flash[:alert] = "You do not have permission to view a different group."
      redirect_to group_path(current_user.group)
    end

    @donations = Donation.where(user_id: @group.users.pluck(:id))
  end

  # GET /groups/new
  def new
    if current_user.user_type.downcase != "admin"
      flash[:alert] = "You do not have permission to create a new group."
      redirect_to group_path(current_user.group)
    end

    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])

    if current_user.user_type.downcase != "admin" && current_user.group != @group
      flash[:alert] = "You do not have permission to edit a different group."
      redirect_to group_path(current_user.group)
    end
  end

  def delete
    @group = Group.find(params[:id])
    
    if current_user.user_type.downcase != "admin" && current_user.group != @group
      flash[:alert] = "You do not have permission to delete a different group."
      redirect_to group_path(current_user.group)
    end
  end

  # POST /groups or /groups.json
  def create
    @group = Group.new(group_params)

    if current_user.user_type.downcase != "admin"
      return
    end

    respond_to do |format|
      if @group.save
        format.html { redirect_to group_url(@group), notice: "Group was successfully created." }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    if current_user.user_type.downcase != "admin"
      return
    end

    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to group_url(@group), notice: "Group was successfully updated." }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group.destroy

    if current_user.user_type.downcase != "admin"
      return
    end

    respond_to do |format|
      format.html { redirect_to groups_url, notice: "Group was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.require(:group).permit(:name, :org_type)
    end
end
