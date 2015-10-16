$(document).ready(function(){
	$('#datetimepicker').datetimepicker({
		format: 'YYYY-MM-DD hh:mm A'
	});

	resize_window('.messages')

	resize_window('#map')

	$('.messages').scrollTop($('.messages').prop("scrollHeight"));

})

$(window).resize(function() {
	resize_window('.messages')
})

var autocomplete;

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
	var content_height = window_height * .25;
	$(div).height(content_height);
}
