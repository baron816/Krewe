$(document).ready(function(){
	resize_window('.messages')

	resize_window('#map')

	scrollBottom()

	$('.topics > li:first-child').addClass('selected-topic')

	highlightTopic();


	$(".dropdown-button").dropdown();
	$(".button-collapse").sideNav({
		closeOnClick: true
	});
	$('.modal-trigger').leanModal();
	$('.parallax').parallax();
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
	var content_height = window_height * .45;
	$(div).height(content_height);
}

function highlightTopic() {
	$('.topics > li').not(".next-topic").on('click', function () {
		$('.topics > li').removeClass('selected-topic')
		$(this).find('a span').remove()
		$(this).addClass('selected-topic')
	})
}

function setActivityAppointment() {
	var time = $("#time_field").val();
	var date = $("#date_field").val();
	$("#activity_appointment").val(date + " " + time);
}
