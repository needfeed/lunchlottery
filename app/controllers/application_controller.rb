class ApplicationController < ActionController::Base

  protect_from_forgery
  rescue_from RuntimeError, :with => :oh_noes

  protected

  def oh_noes(exception)
    flash[:error] = exception.message
    render "application/error", :status => 400
  end

end
