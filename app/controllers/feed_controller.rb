class FeedController < ApplicationController
  def create
    Feed.create_feed(params[:feed], current_user)
    head :ok
  end
end
