$(document).ready(function(){
	resize_window('.messages')

	resize_window('#map')

	scrollBottom()

	$('.topics > a:first-child').addClass('lighten-3')

	highlightTopic();

	$(".dropdown-button").dropdown();
	$(".button-collapse").sideNav({
		closeOnClick: true
	});
	$('.modal-trigger').leanModal();
	$('.parallax').parallax();
	$('select').material_select();

	$("#map-hider").click(function () {
		$('#map-canvas').toggle();
	})
})

$(window).resize(function() {
	resize_window('.messages')
})



var autocomplete;

function scrollBottom() {
	$('.messages').scrollTop($('.messages').prop("scrollHeight"));
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
