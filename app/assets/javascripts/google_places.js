function mapLocation(startingLat, startingLng) {
	var mapOptions = {
		center: new google.maps.LatLng(startingLat, startingLng),
		zoom: 15
	};

	var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

	var input = document.getElementById('activity_location');

	var autocomplete = new google.maps.places.Autocomplete(input);
	var marker = new google.maps.Marker({
		map: map,
		anchorPoint: new google.maps.Point(0,-29)
	})

	var infowindow = new google.maps.InfoWindow();

	markPlaces(mapOptions, map, infowindow)


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

function markPlaces(mapOptions, map, infowindow) {
	var request = {
		location: mapOptions.center,
		types: ['bar'],
    maxPriceLevel: 2,
    radius: '800',
		rankBy: google.maps.places.RankBy.DISTANCE
	}

	var service = new google.maps.places.PlacesService(map);

	service.radarSearch(request, function(results, status){
		if (status == google.maps.places.PlacesServiceStatus.OK) {
			for (var i = 0; i < results.length; i++) {
				createMarker(results[i], map, infowindow, service)
			}

      $('#spots').append('<li class="list-group-item">Suggested Places</li>')
      for (var i = 0; i < 3; i++) {
        service.getDetails(results[randomNum(results.length)], function (result, status) {
          $('#spots').append('<li class="list-group-item suggested"><button type="button" class="btn btn-primary name"><span class="name">' + result.name + '</span><span class="hidden longitude" >' + result.geometry.location.lng() + '</span><span class="hidden latitude">' + result.geometry.location.lat() + '</span></button></li>')
        })
      }
		}
	})
}



function createMarker(place, map, infowindow, service) {
	var placeLoc = place.geometry.location;
	var marker = new google.maps.Marker({
		map: map,
		position: place.geometry.location,
    icon: {
    url: 'http://maps.gstatic.com/mapfiles/circle.png',
    anchor: new google.maps.Point(10, 10),
    scaledSize: new google.maps.Size(10, 17)
    }
	})


	google.maps.event.addListener(marker, 'click', function() {
		service.getDetails(place, function(result, status) {
		  if (status !== google.maps.places.PlacesServiceStatus.OK) {
		    console.error(status)
        return;
		  }

      infowindow.setContent(result.name);
  		infowindow.open(map, marker);
  		document.getElementById('activity_location').value = result.name;
  		document.getElementById('activity_longitude').value = result.geometry.location.lng()
  		document.getElementById('activity_latitude').value = result.geometry.location.lat()
		})
	})
}

function randomNum(limit) {
  return Math.floor((Math.random() * limit) + 1)
}
