class Admin::AdminController < ApplicationController
  layout "admin"
  before_filter :verify_admin

  def verify_admin (only=false)
    :authenticate_user!
    redirect_to root_url unless has_role?(current_user, 'admin') || (has_role?(current_user, 'developer') if !only)
  end

  def current_ability
    @current_ability ||= AdminAbility.new(current_user)
  end
end