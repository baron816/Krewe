function Formatter() {
  this.responsiveMedia = function() {
  	$(".video").addClass("video-container")
  	$("p img").addClass("responsive-img")
  };

  this.scrollBottom = function(div) {
  	$(div).scrollTop($(div).prop("scrollHeight"));
  };

  this.setBodyHeight = function() {
  	if (/iPad/i.test(navigator.userAgent) && $('.new-message')[0]) {
  		var z = 450 - ($('body').height() - $('.new-message').position().top);
      var that = this;

  		$('.new-message, #new-message-submit').focus(function(){
  			$('body').height("+=" + z)
  			that.scrollBottom('body')
  		})

  		$('.new-message, #new-message-submit').focusout(function () {
  			$('body').height("-=" + z)
  		})

  		$('.new_message').submit(function(){
  			$('body').height("-=" + z)
  		})
  	}
  };

  this.resizeWindow = function(div) {
  	var window_height = $(window).height();
  	var size;

  	if ($("#activity-messages").length) {
  		size = .25
  	} else {
  		size = .45
  	}
  	var content_height = window_height * size;
  	$(div).height(content_height);
  };

  this.setActiveClass = function() {
  	$('input').focus(function(){
  		var label = $("label[for='"+ $(this).attr('id') + "']")

  		label.addClass("active");

  		$(this).focusout(function () {
  			if (!$(this).val()) {
  				label.removeClass("active")
  			}
  		})
  	})
  };

  this.highlightTopic = function() {
  	$('.topics > a:first-child').addClass('lighten-3')

  	$('.topics > a').not(".next-topic").on('click', function () {
  		$('.topics > a').removeClass('lighten-3')
  		$(this).addClass('lighten-3')
  	})
  };

  this.setInitDefaults = function() {
    this.responsiveMedia();
    this.resizeWindow('.messages');
    this.resizeWindow('#map');
    this.scrollBottom('.messages');
    this.highlightTopic();
    this.setBodyHeight()
    this.setActiveClass();
  };

  this.setChangeTopicDefaults = function() {
    this.setBodyHeight();
    this.responsiveMedia();
    this.resizeWindow(".messages");
    this.scrollBottom(".messages");
  }
}
