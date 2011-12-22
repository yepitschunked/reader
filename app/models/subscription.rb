class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed

  delegate :title, :description, :to => :feed
end
