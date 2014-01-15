class WelcomeController < ApplicationController
  def index
  	if !params[:current_customer].blank?
  	  session[:current_customer] = params[:current_customer]
  	end
  end
end
