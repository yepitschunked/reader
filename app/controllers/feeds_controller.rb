class FeedsController < ApplicationController
  def index
    render :json => current_user.feeds_json
  end

  def show
    if params[:id] == 'all'
      render :json => {:title => "All Items", :items => current_user.aggregate_subscription_items.page(params[:page]).as_json(current_user)}
    else
      feed = current_user.feeds.find(params[:id])
      feed.refresh if feed.virgin?
      render :json => feed.as_json(:include => :items)
    end
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
