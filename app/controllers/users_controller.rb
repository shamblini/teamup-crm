class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
  
    # GET /users
    def index
      # Get all the users currently in the database by alphabetical order
      @users = User.order(:id)

      if current_user.user_type != "admin"
        @users = User.where(group: current_user.group).order(:id)
      end

      # Set the current user accessing the page
      @current_user = current_user

      # Set the navbar based on the user status
      @navbar_partial = current_user.user_type.downcase == "admin" ? 'shared/header' : 'shared/header_staff'

      # Render the Index view
      render 'index'
    end

    # Function defining how to go through the uploaded CSV file
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
      if current_user.user_type.downcase != "admin" && @user.group != current_user.group
        flash[:alert] = "You do not have permission to view that page."
        redirect_to root_path
      end
    end
  
    # GET /users/new
    def new
      @user = User.new
      if current_user.nil
        render 'new_user'
      elsif current_user.user_type.downcase == "admin"
        render 'new'
      else
        render 'new_staff'
      end
    end
  
    # GET /users/1/edit
    def edit
      @user = User.find(params[:id])

      # Staff only has permission to edit their group users, Admins can edit all
      if current_user.user_type.downcase != "admin" && @user.group != current_user.group
        flash[:alert] = "You do not have permission to view that page."
        redirect_to root_path
      end

      if current_user.user_type.downcase == "admin"
        render 'edit'
      else
        render 'edit_staff'
      end
    end
  
    # POST /users
    def create
      @user = User.new(user_params)

      # non admins cannot create admin users
      if current_user.user_type.downcase != "admin" && params[:user][:user_type]&.downcase == "admin"
        flash[:alert] = "You do not have permission to create an Admin User."
        redirect_to users_path and return
      end

      # non admin users cannot set the group of a user
      if current_user.user_type.downcase != "admin"
        @user.group = current_user.group
      end

      # Save the user to the db and notify if it was successful
      if @user.save
        redirect_to @user, notice: 'User was successfully created.'
      else
        render :new
      end
    end
  
    # PATCH/PUT /users/1
    def update
      @user = User.find(params[:id])
      restrict_edit_access if current_user.user_type.downcase != "admin"

      # Non admins cannot change a user to admin
      if current_user.user_type.downcase != "admin" && params[:user][:user_type]&.downcase == "admin"
        flash[:alert] = "You do not have permission to change a user to Admin."
        redirect_to users_path and return
      end

      # Non admins cannot change users not in their group
      if current_user.user_type.downcase != "admin" && current_user.group != @user.group
        flash[:alert] = "You do not have permission to change a user not in your group."
        redirect_to users_path and return
      end

      # Update the user in the database and notify that it was succcessful
      if @user.update(user_params)
        redirect_to @user, notice: 'User was successfully updated.'
      else
        render :edit
      end
    end
  
  
    # DELETE /users/1 or /users/1.json
    def delete
      @user = User.find(params[:id])

      # Non admins can only delete staff in their group
      if current_user.user_type.downcase != "admin" && current_user.group != @user.group
        flash[:alert] = "You do not have permission to delete a user not in your group."
        redirect_to users_path and return
      end
    end

    def destroy
      @user = User.find(params[:id])

      # Non admins can only delete staff in their group
      if current_user.user_type.downcase != "admin" && current_user.group != @user.group
        flash[:alert] = "You do not have permission to destroy a user not in your group."
        redirect_to users_path and return
      end

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
  