class FeedsController < ApplicationController
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
