$(document).ready(function(){
	$('#datetimepicker').datetimepicker({
		format: 'YYYY-MM-DD hh:mm A'
	});

	$('#address-info').change( function () {
		codeAddress()
	});

	$("#user_state").select2({
		placeholder: "Select a state"
	});

	resize_window('.messages')

	resize_window('#map')

	$('.messages').scrollTop($('.messages').prop("scrollHeight"));
})

$(window).resize(function() {
	resize_window('.messages')
})

function resize_window(div) {
	var window_height = $(window).height();
	var content_height = window_height * .25;
	$(div).height(content_height);
}

function codeAddress() {
	geocoder = new google.maps.Geocoder()
	var address = $('#user_street').val() + ", " + $('#user_city').val() + ", " + $('#user_state').val();
	geocoder.geocode( { 'address': address}, function (results, status) {
		if (status == google.maps.GeocoderStatus.OK) {
			var lat = results[0].geometry.location.lat()
			var lng = results[0].geometry.location.lng()
			$('#lat').val(lat)
			$('#lng').val(lng)
		} else {
			console.log("error" + status);
		}
	})
}
