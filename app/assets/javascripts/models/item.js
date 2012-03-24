Reader.Models.Item = Backbone.Model.extend({
  initialize: function() {
    this.on('change:read', function() {
      if(this.get('read')) {
        $.ajax({
          url: '/items/'+this.get('id')+'/read',
          type: 'put',
        });
      }
    });
  }
});
