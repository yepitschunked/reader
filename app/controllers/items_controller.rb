class ItemsController < ApplicationController
  def read
    r = Reading.find_or_initialize_by_user_id_and_item_id(current_user.id, params[:item_id])
    r.save if r.new_record?
    head :ok
  end

  def index
    if sub = Subscription.find_by_id(params[:subscription_id])
      render :json => sub.items
    else
      render :json => Item.all
    end
  end
end
