window.Reader = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  init: function() {
    window.feed_router = new Reader.Routers.Feeds({feeds: Reader.starting_feeds});
    Backbone.history.start();
  }
};

$(document).ready(function(){
  Reader.init();
});
