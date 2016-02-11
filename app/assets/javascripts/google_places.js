markers = [];
var plan;
var autocomplete;

function mapLocation(startingLat, startingLng) {
	mapOptions = {
		center: new google.maps.LatLng($("#map-canvas").data("latitude"), $("#map-canvas").data("longitude")),
		zoom: 15
	};

	map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

	var input = document.getElementById('activity_location');

	var autocomplete = new google.maps.places.Autocomplete(input);

	infowindow = new google.maps.InfoWindow();

	markPlaces()

	google.maps.event.addListener(autocomplete, 'place_changed', function () {
		var place = autocomplete.getPlace();

  	var marker = new google.maps.Marker({
  		map: map,
  		anchorPoint: new google.maps.Point(0,-29)
  	})
    markers.push(marker);
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

function mapActivityLocation() {
	var latLng = new google.maps.LatLng($("#map-canvas").data("latitude"), $("#map-canvas").data("longitude"))

	mapOptions = {
		center: latLng,
		zoom: 17
	};

	map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

	var marker = new google.maps.Marker({
		position: latLng,
		map: map,
		anchorPoint: new google.maps.Point(0,-29)
	})
}

$(document).on('click', '.suggested', function() {
	var item = $(this);

  var service = new google.maps.places.PlacesService(map)

  service.getDetails({
    placeId: item.data().placeid
  }, function (place, status) {
    if (status === google.maps.places.PlacesServiceStatus.OK) {
      var marker = new google.maps.Marker({
        map: map,
        position: place.geometry.location
      });
      markers.push(marker)

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

      $('#activity_location').val(place.name)
    	$('#activity_latitude').val(place.geometry.location.lat());
    	$('#activity_longitude').val(place.geometry.location.lng());

			$('#activity_plan').val(plan || 'Get Drinks')

			$('label[for="activity_plan"]').addClass("active")
			$('label[for="activity_location"]').addClass("active")
    }
  })
})

function markPlaces(type) {
	var request = {
		location: mapOptions.center,
		types: [type || 'bar'],
    radius: '1600',
		rankBy: google.maps.places.RankBy.DISTANCE
	}

	var service = new google.maps.places.PlacesService(map);

	service.radarSearch(request, function(results, status){
		if (status == google.maps.places.PlacesServiceStatus.OK) {
			for (var i = 0; i < results.length; i++) {
				createMarker(results[i], service)
			}
			var resultsSample = _.sample(results, 3)

      for (var i = 0; i < 3; i++) {
      	service.getDetails(resultsSample[i], function(result, status){
          var location = result.geometry.location
          $('#spots').append('<a href="#" class="collection-item suggested" data-placeid="' + result.place_id + '">' + result.name + '</a>')
				})
      }
		}
	})
}

$(document).on('click', '.place-type', function () {
    $('.suggested').remove()
    clearMarkers()
    map.setZoom(15)
    plan = $(this).data().plan

    markPlaces($(this).data().type);
})

function createMarker(place, service) {
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
  markers.push(marker)

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

			$('label[for="activity_location"]').addClass("active")
		})
	})
}

function initAutoComplete() {
	autocomplete = new google.maps.places.Autocomplete(
		/** @type {!HTMLInputElement} */(document.getElementById('user_address')),
      {types: ['address']});

	autocomplete.addListener('place_changed', setCoordinates)
}

function setCoordinates() {
	var place = autocomplete.getPlace();
	var geo = place.geometry.location

	$('#lat').val(geo.lat())
	$('#lng').val(geo.lng())
}

function resize(lat, lng) {
	google.maps.event.trigger(map, 'resize')
	map.setCenter(new google.maps.LatLng(lat, lng))
}

function setMapOnAll(map) {
  for (var i = 0; i < markers.length; i++) {
    markers[i].setMap(map);
  }
}

function clearMarkers() {
  setMapOnAll(null);
}
