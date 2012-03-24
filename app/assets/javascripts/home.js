
$(function() {
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
      var s = $(window).scrollTop(),
        d = $(document).height(),
        c = $(window).height();
        scrollPercent = (s / (d-c)) * 100;

      if(items.first().offset().top > window.pageYOffset) {
        items.first().trigger('focus')
      }
      else if(scrollPercent > 99) {
        items.last().trigger('focus');
      }
      else {
        $('.item').each(function() {
          if(window.pageYOffset > $(this).offset().top - $(this).prev().outerHeight()*0.55 ) {
            $(this).trigger('focus');
          }
        });
      }
    }
  }, 250);
});

