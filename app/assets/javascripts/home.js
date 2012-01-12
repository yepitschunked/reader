var item_prototype = $('<div/>', {'class': 'item'}).append($('<a/>', {'class': 'title'})).append($('<div/>', {'class': 'time_delta'})).append($('<div/>', {'class': 'body'}));

$(function() {
  $('li.subscription a').live('click', function(e) {
    $.getJSON($(this).attr('href'), 
      { only_unread: $('#only_unread').is(':checked') },
      function(json) {
        $('.content').empty();
        $.each(json.items, function(idx, item) {
          var entry = item_prototype.clone();
          entry.data('item-id', item.id);
          entry.find('.title').text(item.title).attr('href', item.original_location);
          entry.find('.time_delta').text(item.time_delta);
          entry.find('.body').html(item.content);
          if(item.read) {
            entry.addClass('read')
          }
          $('.content').append(entry);
          $('.content').find('.item').first().attr('id', 'viewing');

          $('#sidebar li.subscription.selected').removeClass('selected');
          $('#sub_'+(json.id || "all")).addClass('selected');
        });
    });
    e.preventDefault();
    return false;
  });

  $('li.subscription.selected a').click();

  $('.item').live({
    'click': function() {
      if(!$(this).is('.read')) {
        $(this).trigger('read');
      }
      $(this).trigger('focus');
      $(window).scrollTop($(this).offset().top);
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
  var scrollPrev = window.pageYOffset;
  var scrollDirection = 0; // 0 for up, 1 for down

  $(window).scroll(function() {
    clearTimeout(scrollTimer);
    scrollTimer = setTimeout(function() {
      didScroll = true;
      scrollDirection = (scrollPrev > window.pageYOffset) ? 0 : 1;
      scrollPrev = window.pageYOffset;
    }, 25);
  });

  setInterval(function() {
    if ( didScroll ) {
      didScroll = false;
      // Check your page position and then
      // Load in more results
      var scroll_padding = scrollDirection ? -0.2 : 0.55;
      var items = $('.item');
      if(items.first().offset().top > window.pageYOffset) {
        items.first().trigger('read').trigger('focus');
      }
      else {
        $('.item').each(function() {
          if(window.pageYOffset > $(this).offset().top - $(this).prev().outerHeight()*0.55 ) {
            $(this).trigger('read').trigger('focus');
          }
        });
      }
    }
  }, 250);
});

