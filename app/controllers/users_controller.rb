class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
  
    # GET /users
    def index
      @users = User.order(:id)
      @current_user = current_user
      @users_to_display = []

  
      @users.each do |user|
        if (@current_user.user_type != "Admin" && user.group == @current_user.group) || (@current_user.user_type == "Admin")
          @users_to_display << user
        end
      end

      render 'index'
    end

    require 'csv'
    def upload_csv
      uploaded_file = params[:csv_file]
      
      begin
        CSV.foreach(uploaded_file.path, headers: true) do |row|
          user_data = row.to_h
          User.create!(user_data)
        end
        flash[:success] = "CSV file uploaded successfully."
      rescue StandardError => e
        flash[:error] = "Error uploading CSV file: #{e.message}"
      end
      
      redirect_to donations_path
    end
  
    # GET /users/1
    def show
    end
  
    # GET /users/new
    def new
      @user = User.new
    end
  
    # GET /users/1/edit
    def edit

    end
  
    # POST /users
    def create
      @user = User.new(user_params)
  
      if @user.save
        redirect_to @user, notice: 'User was successfully created.'
      else
        render :new
      end
    end
  
    # PATCH/PUT /users/1
    def update
      @user = User.find(params[:id])
      restrict_edit_access if @user.user_type.downcase == "staff"

      if params[:user][:user_type]&.downcase == "admin"
        flash[:alert] = "You do not have permission to change a user to Admin."
        redirect_to users_path and return
      end

      if current_user.group != @user.group
        flash[:alert] = "You do not have permission to change a user not in your group."
        redirect_to users_path and return
      end
  
      if @user.update(user_params)
        redirect_to @user, notice: 'User was successfully updated.'
      else
        render :edit
      end
    end
  
  
    # DELETE /users/1 or /users/1.json
    def delete
      @user = User.find(params[:id])
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy

      respond_to do |format|
        format.html { redirect_to(users_url, notice: 'user was successfully destroyed.') }
        format.json { head(:no_content) }
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def user_params
        params.require(:user).permit(:name, :email, :user_type, :donations_id, :permission_set_id, :group_id)
      end

      def restrict_edit_access
        params[:user].delete(:group_id) # Remove group_id parameter if user is staff
      end
  end
  