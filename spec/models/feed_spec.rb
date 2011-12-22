require 'spec_helper'

describe Feed do
  describe "create_feed" do
    it "should create a feed and subscribe the user to it" do
      Feed.any_instance.stub(:refresh) { nil }
      user = Factory.create(:user)
      feed = Feed.create_feed({:original_location => 'test.test'}, user)
      feed.subscriptions.first.user.should == user
    end
  end

  describe "#refresh" do
    before do
      dummy_feed_items = Factory.build_list(:unprocessed_item, 10) 
      @dummy_rss_feed = mock(:title => 'fake', :description => 'fake', :entries => dummy_feed_items)
      Feed.any_instance.stub(:feed).and_return(@dummy_rss_feed)
      @feed = Feed.create(:original_location => 'test.test', :title => 'test', :description => 'test') 
    end

    subject { @feed }

    it "should update title and description" do
      subject.refresh
      subject.title.should == @dummy_rss_feed.title
      subject.description.should == @dummy_rss_feed.description
    end

    context "without any existing items" do
      it "should create items for all the articles in the feed" do
        subject.refresh
        subject.items.length.should == @dummy_rss_feed.entries.length
      end
    end

    context "with existing items" do
      before do
        encountered_item_id = Digest::MD5.hexdigest('encountered')
        subject.items = [Factory.build(:item, :item_id => encountered_item_id)]

        @dummy_rss_feed.stub(:entries).and_return([
          Factory.build(:unprocessed_item, :url => 'new item 1'), 
          Factory.build(:unprocessed_item, :url => 'encountered'),
          Factory.build(:unprocessed_item, :url => 'not new item')
        ])
      end

      it "should create items for all unencountered items in the feed" do
        subject.refresh
        subject.items.length.should == 2
      end
    end
  end
end
      
