class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  before_filter :set_current_user

  def set_current_user
    Thread.current[:user] = current_user
  end
  protect_from_forgery
end
