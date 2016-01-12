function Activity() {
  this.activitySetup = function() {
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

  var setActivityAppointment = function() {
  	var time = $("#time_field").val();
  	var date = $("#date_field").val();
  	$("#activity_appointment").val(date + " " + time);
  }
}
