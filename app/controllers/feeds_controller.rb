class FeedsController < ApplicationController
  def create
    if params[:google_opml]
      Feed.create_from_opml(params[:google_opml], current_user)
    else
      Feed.create_feed(params[:feed], current_user)
      head :ok
    end
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
    feed = current_user.feeds.find(params[:id], :include => {:items => :readings})
    feed.refresh if feed.virgin?
    render :json => feed.as_json(:include => :items, :for_user => current_user)
  end
end
