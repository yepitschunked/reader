Reader.Models.Feed = Backbone.Model.extend({
  initialize: function(attrs) {
    this.items = new Reader.Collections.Items(attrs.items);
    this.items.url = '/feeds/' + this.id + '/items';
    this.url = '/feeds/' + this.id;
  }
});
