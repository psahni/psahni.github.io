$(function() {
$('.club-sandwich').click(function(e) {
    if ($('header').hasClass('header-is-extended')){
      e.preventDefault();
    }else{
      e.preventDefault();
      $('body').addClass('has-no-scroll')
      $('header').addClass('header-is-extended')
      $('.extended-nav-wrap').addClass('takes-full-height')
    }
  });

  $('.extended-nav--close').click(function(e) {
    e.preventDefault();
    $('body').removeClass('has-no-scroll')
    $('header').removeClass('header-is-extended')
    $('.extended-nav-wrap').removeClass('takes-full-height')
  });
});
