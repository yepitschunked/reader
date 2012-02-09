class SubscriptionsController < ApplicationController
  def index
    sub = current_user.subscriptions
    render :json => sub
  end
  def show
    session[:active_sub] = params[:id].to_i
    @only_unread = case params[:only_unread]
                  when "true"
                    true
                  when "false"
                    false
                  else
                    false
                  end

    if params[:id].to_i == Subscription::AGGREGATE_SUB
      render :json => {:title => "All", :items => current_user.aggregate_subscription_items.page(params[:page]).as_json(current_user)}
    else
      sub = current_user.subscriptions.find(params[:id])
      sub.feed.refresh if sub.feed.virgin?
      render :json => {:title => sub.title, :id => sub.id, :items => sub.items.as_json(current_user)}
    end
  end
end
