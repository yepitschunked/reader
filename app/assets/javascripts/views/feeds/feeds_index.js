Reader.Views.FeedsIndex = Backbone.View.extend({
  initialize: function() {
    this.feeds = this.options.feeds;
    this.current_feed = this.options.selected;
    this.current_feed_view = new Reader.Views.FeedShow({feed: this.current_feed});
    this.render();
  },
  template: JST['feeds/index'],
  render: function() {
    $(this.el).html(this.template({feeds: this.feeds, selected: this.current_feed}));
    $('#sidebar ul.subscriptions').html(this.el);
    this.current_feed_view.render();
  }
});
