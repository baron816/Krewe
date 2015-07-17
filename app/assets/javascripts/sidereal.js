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
})

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
