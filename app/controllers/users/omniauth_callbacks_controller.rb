class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.find_by(email: from_google_params[:email])

    if user.present? && (user.user_type.downcase == "staff" || user.user_type.downcase == "admin")
      sign_out_all_scopes
      flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect user, event: :authentication
    else
      flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{from_google_params[:email]} is not authorized."
      redirect_to new_user_session_path
    end
  end

  protected

  def after_omniauth_failure_path_for(_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end

  private

  def from_google_params
    @from_google_params ||= {
      email: auth.info.email,
      name: auth.info.name,
    }
  end

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end
