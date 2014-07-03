$(function() {
  var $win;
  $win = $(window);
  return $win.scroll(function() {
    if ($win.scrollTop() > 0) {
      return $('.main-nav-wrap').addClass('header-has-background');
    } else {
      return $('.main-nav-wrap').removeClass('header-has-background');
    }
  });
});
