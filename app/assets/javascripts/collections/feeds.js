Reader.Collections.Feeds = Backbone.Collection.extend({
  model: Reader.Models.Feed,
  url: '/feeds'
});
