class FeedsController < ApplicationController
  def create
    Feed.create_feed(params[:feed], current_user)
    head :ok
  end

  def new
  end

  def refresh
    current_user.subscriptions.includes(:feed).each do |s|
      s.feed.refresh
    end
    head :ok
  end

  def show
    session[:active_feed] = params[:id].to_i
    render :json => current_user.feeds.find(params[:id], :include => {:items => :readings}).as_json(:include => :items, :for_user => current_user)
  end
end
