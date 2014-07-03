$(function() {
$('.extended-nav__item--work').click(function(e) {
    if ($('.work-nav--mobile').hasClass('work-nav--mobile-is-extended')){
      e.preventDefault();
      $('.work-nav--mobile').removeClass('work-nav--mobile-is-extended')
      $('.extended-nav-wrap').removeClass('extended-nav-wrap-is-extended')
    }else{
      e.preventDefault();
      $('.work-nav--mobile').addClass('work-nav--mobile-is-extended')
      $('.extended-nav-wrap').addClass('extended-nav-wrap-is-extended')
    }
  });
});
