class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show edit update destroy ]

  # GET /groups or /groups.json
  def index
    @groups = Group.all
    if params[:sort]
      column = params[:sort]
      direction = params[:direction] == 'asc' ? 'desc' : 'asc'
      @groups = @groups.order("#{column} #{direction}")
    end
    if params[:search]
      search_groups
    end
  end

  def search_groups
    @groups = Group.all
    @group = @groups.find { |group| group.name.include?(params[:search]) }
    
    if @group
      redirect_to group_path(@group)
    else
      flash[:notice] = "No group found with that name '#{params[:search]}'."
      redirect_to groups_path
    end
  end

  # GET /groups/1 or /groups/1.json
  def show
    @group = Group.find(params[:id])
    @users = @group.users.includes(:donations).map { |user| user.attributes.merge(total_donations: user.calculate_total_donations) }
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  def delete
    @group = Group.find(params[:id])
  end

  # POST /groups or /groups.json
  def create
    @group = Group.new(group_params)

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
