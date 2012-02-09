class FeedsController < ApplicationController
  def index
    render :json => current_user.feeds
  end

  def show
    feed = current_user.feeds.find(params[:id])
    feed.refresh if feed.virgin?
    render :json => feed.as_json(:include => :items)
  end
  def create
    # These methods will create a new feed if necessary, otherwise it'll use an existing one
    if params[:google_opml]
      f = Feed.create_from_opml(params[:google_opml], current_user)
    else
      f = Feed.create_feed(params[:feed], current_user)
    end
    current_user.subscribe_to! f
    flash[:notice] = "Feeds successfully added!"
  end
end
