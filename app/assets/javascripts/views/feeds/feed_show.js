Reader.Views.FeedShow = Backbone.View.extend({
  template: JST['feeds/show'],
  render: function() {
    var el = $(this.el);
    this.model.items.each(function(item) {
      var item_view = new Reader.Views.ItemShow({
        model: item
      });
      item_view.render();
      el.append(item_view.el);
    });
    $('.content').empty().append(el);
  }
});
