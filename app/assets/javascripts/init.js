$(document).ready(function(){
  Formatter.setInitDefaults();

  Mentions.mentioning();

	$("#map-hider").click(function () {
		$('#map-canvas').toggle();
	})

  $('.submit-email-button').click(function () {
    $(".new-email-address").show();
    $(".submit-email-button").hide();
  })

  $('#user_address').change( function(){
    if ($('#lat').val().length === 0) {
      $(this).removeClass('valid')
      $(this).addClass("invalid")
    } else {
      $(this).removeClass('invalid')
      $(this).addClass("valid")
    }
  })

	if ($('body').data("notice")) {
		swal($('body').data("notice"));
	}

  if ($(".activities.show").length) {
    GooglePlaces.mapActivityLocation();
  }

  if ($(".activities.edit").length || $(".activities.new").length) {
    Activity.activitySetup();
  }

  if ($('.users.edit').length || $('#user_address').length) {
    GooglePlaces.initAutoComplete();
  }

  $('#new_user').submit(function(event){
    Validator.validateCheckbox(event);
  })

  if ($('#welcome-modal').length) {
    $('#welcome-modal').openModal();
  }

  Message.setMessageBox();
})

$(document).on({
  'DOMNodeInserted': function() {
    $('.pac-item, .pac-item span', this).addClass('needsclick');
  }
}, '.pac-container');

$(window).resize(function() {
	Formatter.resizeWindow('.messages')
})
