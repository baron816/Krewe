const Activity = (function() {
  function activitySetup() {
  	GooglePlaces.mapLocation()

  	$('.datepicker').pickadate({
  	  close: "Done",
  	  min: new Date()
  	})

  	$('#time_field').pickatime({
  	  twelvehour: true
  	})

  	$('#date_field, #time_field').change(function(){
  	  setActivityAppointment()
  	})
  	$('ul.tabs').tabs();
  };

  function setActivityAppointment() {
  	let time = $("#time_field").val();
  	let date = $("#date_field").val();
  	$("#activity_appointment").val(date + " " + time);
  }

  return {
    activitySetup: activitySetup
  }
}())
