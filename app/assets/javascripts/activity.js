function activity() {
  function activitySetup() {
  	mapLocation()

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
  	const time = $("#time_field").val();
  	const date = $("#date_field").val();
  	$("#activity_appointment").val(date + " " + time);
  }

  return {
    activitySetup: activitySetup
  }
}
