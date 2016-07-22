function validator() {
  function validateCheckbox(event) {
  	if ( !document.getElementById("terms_of_service").checked ) {
  		event.preventDefault()
  		swal("Please accept the terms of service")
  	}
  };

  return {
    validateCheckbox: validateCheckbox
  }
}
