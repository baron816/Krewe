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
})