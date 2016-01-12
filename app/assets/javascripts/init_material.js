$(document).ready(function () {
  $(".dropdown-button").dropdown({
    constrain_width: false
  });
  $(".button-collapse").sideNav({
    closeOnClick: true
  });
  $('.modal-trigger').leanModal();
  $('.parallax').parallax();
  $('select').material_select();
  $('.scrollspy').scrollSpy();
  $('.tooltipped').tooltip();
})
