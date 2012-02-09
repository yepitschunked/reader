Reader.Models.Feed = Backbone.Model.extend({
  parse: function(resp) {
    this.items = new Reader.Collections.Items(resp.items);
  },
  initialize: function() {
    this.items = new Reader.Collections.Items();
    this.items.url = '/feeds/' + this.id + '/items';
    this.url = '/feeds/' + this.id;
  }
});
