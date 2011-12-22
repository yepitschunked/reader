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
    $('.content').find('.item').first().attr('id', 'viewing');

    $('#sidebar li.subscription.selected').removeClass('selected');
    $('#feed_'+json.id).addClass('selected');
  });

  $('.item:not(.read)').live({
    'click': function() {
      $(this).trigger('read');
      $(this).trigger('focus');
    },
  });

  $('.item').live('focus', function() {
      $('#viewing').removeAttr('id');
      $(this).attr('id', 'viewing');
  });

  $('.item:not(.read)').live('read', function() {
    $.ajax({
      url: '/items/'+$(this).data('item-id')+'/read',
      type: 'put',
      context: this,
      success: function() {
        $(this).addClass('read');
      }
    });
  });

  var didScroll = false;
  var scrollTimer = null;

  $(window).scroll(function() {
    clearTimeout(scrollTimer);
    scrollTimer = setTimeout(function() {
      didScroll = true;
    }, 150);
  });

  setInterval(function() {
    if ( didScroll ) {
      didScroll = false;
      // Check your page position and then
      // Load in more results
      var scroll_padding = 20;
      var items = $('.item');
      if(items.first().offset().top > window.pageYOffset) {
        items.first().trigger('read').trigger('focus');
      }
      else {
        $('.item').each(function() {
          if($(this).offset().top - window.pageYOffset < $(this).prev().height()*0.33 ) {
            $(this).trigger('read').trigger('focus');
          }
        });
      }
    }
  }, 250);
});

