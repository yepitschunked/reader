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
    Item.where(:feed_id => feeds).order('created_at desc')
  end

  def feeds_json
    ([{:id => 'all', :title => 'All Items', :items => aggregate_subscription_items.page(1).as_json(self)}] + self.feeds).to_json
  end
end
