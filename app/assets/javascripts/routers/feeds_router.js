Reader.Routers.Feeds = Backbone.Router.extend({
  routes: {
    "feeds/:id": "show",
    "": "index"
  },
  index: function() {
    new Reader.Views.FeedsIndex({feeds: Reader.feeds, selected: Reader.feeds.get('all')});
  },
  show: function(id) {
    var feed = Reader.feeds.get(id);
    if(feed.items.isEmpty()) {
      feed.items.fetch({success: function() {
        new Reader.Views.FeedsIndex({feeds: Reader.feeds, selected: feed});
      }});
    }
    else {
      new Reader.Views.FeedsIndex({feeds: Reader.feeds, selected: feed});
    }
  }
});
