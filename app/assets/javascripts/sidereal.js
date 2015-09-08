$(document).ready(function(){
	$('.message-box').on("keyup", function(){
		if ($(this).val().length < 3) {
			$('#new-message-submit').addClass('disabled')
		} else {
			$('#new-message-submit').removeClass('disabled')
		};
	})

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


function mapLocation(startingLat, startingLng) {
	var mapOptions = {
		center: new google.maps.LatLng(startingLat, startingLng),
		zoom: 13
	};

	var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

	var input = document.getElementById('activity_location');

	var autocomplete = new google.maps.places.Autocomplete(input);
	var marker = new google.maps.Marker({
		map: map,
		anchorPoint: new google.maps.Point(0,-29)
	})

	google.maps.event.addListener(autocomplete, 'place_changed', function () {
		var place = autocomplete.getPlace();
		marker.setVisible(false);

		if (!place.geometry) {
			console.log("No geometry")
			return
		}

		if (place.geometry.viewport) {
			map.fitBounds(place.geometry.viewport)
		} else {
			map.setCenter(place.geometry.location);
			map.setZoom(17);
		}

		marker.setIcon(/** @type {google.maps.Icon} */({
			url: place.icon,
			size: new google.maps.Size(71, 71),
      origin: new google.maps.Point(0, 0),
      anchor: new google.maps.Point(17, 34),
      scaledSize: new google.maps.Size(35, 35)
		}));
		marker.setPosition(place.geometry.location);
		marker.setVisible(true);
		$('#activity_latitude').val(place.geometry.location.lat());
		$('#activity_longitude').val(place.geometry.location.lng());
	})
}
