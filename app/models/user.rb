class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :subscriptions
  has_many :feeds, :through => :subscriptions
  has_many :readings

  def subscribe_to!(*feeds)
    self.feeds << feeds
  end

  def aggregate_subscription_items(only_unread = false)
    items_sql = subscriptions.inject(nil) do |items, s|
      i = (only_unread ? s.unread_items : s.items)
      if items
        items.union(i)
      else
        i
      end
    end.to_sql
    Subscription::AggregateSubscriptionItems.new(items_sql)
  end
end
