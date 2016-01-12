$(window).resize(function() {
	new Formatter().resizeWindow('.messages')
})

function setMessageBox() {
	$('.new-message').on('keyup', function(){
		$('#message_content').val($('.new-message').html())
	})

	$('#new-message-submit').click(function(){
		$('.new-message').empty()
	})
}

function validateCheckbox(event) {
	if ( !document.getElementById("terms_of_service").checked ) {
		event.preventDefault()
		swal("Please accept the terms of service")
	}
}
