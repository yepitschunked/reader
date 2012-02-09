
$(function() {
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

