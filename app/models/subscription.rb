class Subscription < ActiveRecord::Base
  module PaginatableItems
    PAGE_SIZE = 10
    def page(n)
      proxy_association.scoped.limit(PAGE_SIZE).offset(PAGE_SIZE * n)
    end
  end
  belongs_to :user
  belongs_to :feed

  delegate :title, :description, :refresh, :to => :feed
  has_many :items, :through => :feed, :source => :items, :extend => PaginatableItems
  has_many :read_items, :through => :feed, :source => :items, :conditions => proc {
    "exists ( select * from readings where readings.item_id = items.id AND readings.user_id = #{user_id} )"
  }, :extend => PaginatableItems

  has_many :unread_items, :through => :feed, :source => :items, :conditions => proc {
    "not exists ( select * from readings where readings.item_id = items.id AND readings.user_id = #{user_id} )"
  }, :extend => PaginatableItems

  AGGREGATE_SUB = -1

  class AggregateSubscriptionItems
    def initialize(finder_sql)
      @finder_sql = "#{finder_sql} ORDER BY created_at desc LIMIT :limit OFFSET :offset"
    end

    def page(n)
      n ||= 0
      Item.find_by_sql([@finder_sql, {:limit => PaginatableItems::PAGE_SIZE, :offset => PaginatableItems::PAGE_SIZE * n}])
    end
  end

end
