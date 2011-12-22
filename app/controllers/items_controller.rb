class ItemsController < ApplicationController
  def read
    current_user.readings.create(:item_id => params[:item_id])
    head :ok
  end
end
