var item_prototype = $('<div/>', {'class': 'item'}).append($('<a/>', {'class': 'title'})).append($('<div/>', {'class': 'body'}));

$(function() {
  $('li.subscription.selected a').click();
  $('li.subscription').live('ajax:success', function(e, json) {
    $('.content').empty();
    $.each(json.items, function(idx, item) {
      var entry = item_prototype.clone();
      entry.data('item-id', item.id);
      entry.find('.title').html(item.title).attr('href', item.original_location);
      entry.find('.body').html(item.content);
      if(item.read) {
        entry.addClass('read')
      }
      $('.content').append(entry);
    });

    $('#sidebar li.subscription.selected').removeClass('selected');
    $('#feed_'+json.id).addClass('selected');
  });

  $('.item:not(.read)').live('click', function() {
    $.ajax({
      url: '/items/'+$(this).data('item-id')+'/read',
      type: 'put',
      context: this,
      success: function() {
        $(this).addClass('read');
      }
    });
  });
});

