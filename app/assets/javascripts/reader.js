window.Reader = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  init: function(options) {
    this.feeds = new Reader.Collections.Feeds().reset(options.feeds);
    this.feed_router = new Reader.Routers.Feeds();
    Backbone.history.start();
  }
};
