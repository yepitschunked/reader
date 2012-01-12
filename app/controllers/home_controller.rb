class HomeController < ApplicationController
  def index
    session[:active_sub] ||= current_user.feeds.first.try(:id)
  end
end
