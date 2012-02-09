Reader.Routers.Feeds = Backbone.Router.extend({
  routes: {
    "feeds/:id": "show",
    "": "index"
  },

  index: function() {
    var feeds = new Reader.Collections.Feeds();
    feeds.fetch({
      success: function() {
        new Reader.Views.FeedsIndex({feeds: feeds});
      }
    });
  },
  show: function(id) {
    this.index();
    var feed = new Reader.Models.Feed({id: id});
    feed.fetch({
      success: function(feed, resp) {
        new Reader.Views.FeedShow({feed: feed});
      }
    });
  }
});
