class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :store_current_location, :unless => :devise_controller?

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, :alert => exception.message
  end
  
protected
  # def after_sign_in_path_for(resource)
  #   if resource.role == 'admin'
  #     rails_admin_path
  #   else
  #     request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  #   end
  # end

  def store_current_location
    store_location_for(:user, request.url) if request.get? 
  end

end
