class ItemsController < ApplicationController
  def read
    r = Reading.find_or_initialize_by_user_id_and_item_id(current_user.id, params[:item_id])
    r.save if r.new_record?
    head :ok
  end
end
