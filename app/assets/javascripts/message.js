function Message() {
  this.setMessageBox = function() {
  	$('.new-message').on('keyup', function(){
  		$('#message_content').val($('.new-message').html())
  	})

  	$('#new-message-submit').click(function(){
  		$('.new-message').empty()
  	})
  };
}
