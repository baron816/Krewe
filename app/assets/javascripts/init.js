$(document).ready(function(){
  new Formatter().setInitDefaults();

  new Mentions().mentioning();

	$("#map-hider").click(function () {
		$('#map-canvas').toggle();
	})

	if ($('body').data("notice")) {
		swal($('body').data("notice"));
	}

  if ($(".activities.show").length) {
    mapActivityLocation();
  }

  if ($(".activities.edit").length || $(".activities.new").length) {
    new Activity().activitySetup();
  }

  if ($('.users.edit').length || $('.users.new').length) {
    initAutoComplete();
  }

  $('#new_user').submit(function(event){
    new Validator().validateCheckbox(event);
  })

  new Message().setMessageBox();
})

$(document).on({
  'DOMNodeInserted': function() {
    $('.pac-item, .pac-item span', this).addClass('needsclick');
  }
}, '.pac-container');

$(window).resize(function() {
	new Formatter().resizeWindow('.messages')
})
