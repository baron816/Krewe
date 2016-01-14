function Validator() {
  this.validateCheckbox = function(event) {
  	if ( !document.getElementById("terms_of_service").checked ) {
  		event.preventDefault()
  		swal("Please accept the terms of service")
  	}
  };
}
