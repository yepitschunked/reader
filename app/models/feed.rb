require 'jobs/feed_refresh_job'
class Feed < ActiveRecord::Base
  has_many :items, :dependent => :destroy do
    def latest_item
      order('created_at desc').first
    end
  end
  has_many :subscriptions
  has_many :users, :through => :subscriptions

  validates_presence_of :original_location

  after_create :queue_refresh

  def queue_refresh
    Resque.enqueue(FeedRefreshJob, self.id)
  end

  def self.create_from_opml(opml_file, user)
    parsed = Nokogiri.parse(opml_file.read)
    feeds = []
    Feed.transaction do
      parsed.css('outline').each do |sub|
        attrs = sub.attributes
        feed = Feed.find_or_initialize_by_original_location(attrs['xmlUrl'].value)
        feed.title = attrs['title'].value
        feed.save! if feed.new_record?
        feeds << feed
      end
    end
    feeds
  end

  def self.create_feed(params, user)
    feed = Feed.find_or_initialize_by_original_location(params[:original_location])
    Feed.transaction do
      feed.save! if feed.new_record?
    end

    feed
  end

  def feed
    @feed || Feedzirra::Feed.fetch_and_parse(original_location)
  end

  def virgin?
    last_updated.blank?
  end

  def refresh
    raise unless persisted?
    @feed = nil # clear any cached feed
    case feed
    when 0
      self.error = "NXDOMAIN"
    when Fixnum
      self.error = "HTTP_STATUS #{feed}"
    when nil
      self.error = "NOT_A_FEED"
    else
      self.title = self.feed.title
      Item.import build_items(self.feed)
      self.last_updated = Time.now
      self.items(true)
    end
    self.save
  end

  private
  def build_items(feed)
    freshest_item = self.items.latest_item
    items = []
    feed.entries.each do |external_item|
      if freshest_item && freshest_item.same_as_external?(external_item)
        break
      else
        items << Item.build_from_feed_item(self, external_item)      end
    end
    items
  end
end
