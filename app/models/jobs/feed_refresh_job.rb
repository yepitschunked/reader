class FeedRefreshJob
  @queue = :refresh

  def self.perform(feed_id)
    Feed.find(feed_id).refresh
  end
end
