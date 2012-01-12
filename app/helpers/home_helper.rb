module HomeHelper
  def subscription_link(sub)
    li_attrs = nil
    link_attrs = nil
    if sub == Subscription::AGGREGATE_SUB
      li_attrs = {:id => "sub_all", "data-sub-id" => sub, :class => "subscription #{('selected' if session[:active_sub] == sub)}"}
      link_attrs = ["All", user_subscription_path(current_user, sub)]
    else
      li_attrs = {:id => "sub_#{sub.id}", 'data-sub-id' => sub.id, :class => "subscription #{('selected' if session[:active_sub] == sub.id)}"}
      link_attrs = [sub.title, user_subscription_path(current_user, sub), {:title => sub.description}]
    end
    content_tag(:li, li_attrs) do
      link_to(*link_attrs)
    end
  end
end
