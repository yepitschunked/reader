require 'rss_parser'
class Feed < ActiveRecord::Base
  has_many :items do
    def latest_item
      order('created_at desc').first
    end
  end
  has_many :subscriptions
  has_many :users, :through => :subscriptions

  validates_presence_of :original_location

  after_create :refresh

  def self.create_feed(params, user)
    feed = Feed.find_or_initialize_by_original_location(params[:location])
    Feed.transaction do
      feed.save! if feed.new_record?
      feed.subscriptions.create(:user => user)
    end

    feed
  end

  def feed
    @feed || ReaderRSSParser.parse(open(self.original_location))
  end

  def refresh
    raise unless persisted?
    @feed = nil # clear any cached feed
    self.title = self.feed.title
    self.description = self.feed.description
    Item.import build_items(self.feed)
    self.items(true)
    self.save
  end

  private
  def build_items(feed)
    freshest_item = self.items.latest_item
    items = []
    feed.items.each do |external_item|
      if freshest_item && (external_item.id == freshest_item.item_id)
        break
      else
        items << Item.build_from_feed_item(self, external_item)      end
    end
    items
  end
end
