$(document).ready(function(){
	resize_window('.messages')

	resize_window('#map')

	scrollBottom('.messages')

	$('.topics > a:first-child').addClass('lighten-3')

	highlightTopic();

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

	$("#map-hider").click(function () {
		$('#map-canvas').toggle();
	})

	setBodyHeight()

	responsiveMedia();

	app.reload();
})

$(window).resize(function() {
	resize_window('.messages')
})



var autocomplete;

function responsiveMedia() {
	$(".video").addClass("video-container")
	$("p img").addClass("responsive-img")
}

function scrollBottom(div) {
	$(div).scrollTop($(div).prop("scrollHeight"));
}

function setBodyHeight() {
	if ($('.new-message')[0]) {
		var z = 450 - ($('body').height() - $('.new-message').position().top)

		$('.new-message, #new-message-submit').focus(function(){
			$('body').height("+=" + z)
			scrollBottom('body')
		})

		$('.new-message, #new-message-submit').focusout(function () {
			$('body').height("-=" + z)
		})
	}
}

function initAutoComplete() {
	autocomplete = new google.maps.places.Autocomplete(
		/** @type {!HTMLInputElement} */(document.getElementById('user_address')),
      {types: ['geocode']});

	autocomplete.addListener('place_changed', setCoordinates)
}

function setCoordinates() {
	var place = autocomplete.getPlace();
	var geo = place.geometry.location

	$('#lat').val(geo.lat())
	$('#lng').val(geo.lng())
}

function resize_window(div) {
	var window_height = $(window).height();
	var size;

	if ($("#activity-messages").length) {
		size = .25
	} else {
		size = .45
	}
	var content_height = window_height * size;
	$(div).height(content_height);
}

function highlightTopic() {
	$('.topics > a').not(".next-topic").on('click', function () {
		$('.topics > a').removeClass('lighten-3')
		$(this).addClass('lighten-3')
	})
}

function setActivityAppointment() {
	var time = $("#time_field").val();
	var date = $("#date_field").val();
	$("#activity_appointment").val(date + " " + time);
}

function validateCheckbox(event) {
	if ( !document.getElementById("terms_of_service").checked ) {
		event.preventDefault()
		swal("Please accept the terms of service")
	}
}
