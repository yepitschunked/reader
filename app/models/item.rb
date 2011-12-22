class Item < ActiveRecord::Base
  belongs_to :feed

  validates_uniqueness_of :item_id
  validates_presence_of :title, :original_location

  def self.build_from_feed_item(feed, item)
    Item.new(:feed => feed, :title => item.title, :content => item.content, :original_location => item.urls.first, :item_id => item.id)
  end

end
