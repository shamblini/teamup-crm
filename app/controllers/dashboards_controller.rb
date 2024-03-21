class DashboardsController < ApplicationController
  def index
    @current_user = current_user

    if @current_user.user_type&.downcase == "admin"
      @navbar_partial = 'shared/header'
      @partial_to_render = 'admin'
    elsif @current_user.user_type&.downcase == "staff"
      @navbar_partial = 'shared/header_staff'
      @partial_to_render = 'staff'
    else
      @partial_to_render = 'new_user'
    end
  end
end
