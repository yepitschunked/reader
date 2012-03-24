class ItemsController < ApplicationController
  def read
    r = Reading.find_or_initialize_by_user_id_and_item_id(current_user.id, params[:item_id])
    r.save if r.new_record?
    head :ok
  end

  def index
    if feed = Feed.find_by_id(params[:feed_id])
      render :json => feed.items.page(params[:page]).as_json(current_user)
    elsif params[:feed_id] == 'all'
      render :json => current_user.aggregate_subscription_items.page(params[:page]).as_json(current_user)
    elsif params[:feed_id].blank?
      render :json => Item.all
    end
  end
end
