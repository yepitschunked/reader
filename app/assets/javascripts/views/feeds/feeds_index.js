Reader.Views.FeedsIndex = Backbone.View.extend({
  initialize: function() {
    this.feeds = this.options.feeds;
    this.render();
  },
  template: JST['feeds/index'],
  render: function() {
    $(this.el).html(this.template({feeds: this.feeds}));
    $('#sidebar ul.subscriptions').html(this.el);
  }

});
