$(document).ready(function(){
  new Formatter().setInitDefaults();

  new Mentions().mentioning();

	$("#map-hider").click(function () {
		$('#map-canvas').toggle();
	})

  $('.submit-email-button').click(function () {
    $(".new-email-address").show();
    $(".submit-email-button").hide();
  })

	if ($('body').data("notice")) {
		swal($('body').data("notice"));
	}

  if ($(".activities.show").length) {
    mapActivityLocation();
  }

  if ($(".activities.edit").length || $(".activities.new").length) {
    new Activity().activitySetup();
  }

  if ($('.users.edit').length || $('#user_address').length) {
    initAutoComplete();
  }

  $('#new_user').submit(function(event){
    new Validator().validateCheckbox(event);
  })

  if ($('#welcome-modal').length) {
    $('#welcome-modal').openModal();
  }

  new Message().setMessageBox();
})

$(document).on({
  'DOMNodeInserted': function() {
    $('.pac-item, .pac-item span', this).addClass('needsclick');
  }
}, '.pac-container');

$(window).resize(function() {
	new Formatter().resizeWindow('.messages')
})
