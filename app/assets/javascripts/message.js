const Message = (function() {
  function setMessageBox() {
  	$('.new-message').on('keyup', function(){
  		$('#message_content').val($('.new-message').html())
  	})

  	$('#new-message-submit').click(function(){
  		$('.new-message').empty()
  	})
  };

  return {
    setMessageBox: setMessageBox
  }
}())
