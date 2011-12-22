require 'spec_helper'
describe Item do
  describe "creation from feed entry" do
    before do
      @feed = Factory.build(:feed)
      @feed_item = Factory.build(:unprocessed_item)
    end

    it "should copy over title, content, url, and item id" do
      item = Item.build_from_feed_item(@feed, @feed_item)
      item.title.should == @feed_item.title
      item.content.should == @feed_item.content
      item.original_location.should == @feed_item.url
      item.item_id.should == Digest::MD5.hexdigest(@feed_item.url)
    end
  end
end


