class Item < ActiveRecord::Base
  belongs_to :feed
  has_many :readings
  has_many :readers, :through => :readings, :source => :user

  validates_uniqueness_of :item_id
  validates_presence_of :title, :original_location

  def self.build_from_feed_item(feed, item)
    Item.new(:feed => feed, :title => item.title, :content => "#{item.summary}\n#{item.content}", :original_location => item.url, :item_id => Digest::MD5.hexdigest(item.url))
  end

  def same_as_external?(external_item)
    Digest::MD5.hexdigest(external_item.url) == self.item_id
  end

  def read_by?(user)
    self.readings.map(&:user_id).include?(user.id)
  end

  def as_json(user)
    if user
      hash = super()
      hash.merge!({:read => read_by?(user)})
    else
      super
    end
  end
end
