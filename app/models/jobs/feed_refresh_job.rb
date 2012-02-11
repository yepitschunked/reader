class FeedRefreshJob
  @queue = :refresh

  def self.perform(feed_id)
    feed = Feed.find(feed_id)
    if feed.last_updated < 1.hour.ago
      feed.refresh
    end
  end
end
