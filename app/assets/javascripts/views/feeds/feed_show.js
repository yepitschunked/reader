Reader.Views.FeedShow = Backbone.View.extend({
  initialize: function() {
    this.feed = this.options.feed;
    this.render();
  },
  template: JST['feeds/show'],
  render: function() {
    $(this.el).html(this.template({feed: this.feed}));
    $('.content').html(this.el);
  }

});
