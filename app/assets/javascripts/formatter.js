const Formatter = (function () {
  function responsiveMedia() {
  	$(".video").addClass("video-container")
  	$("p img").addClass("responsive-img")
  };

  function scrollBottom(div) {
  	$(div).scrollTop($(div).prop("scrollHeight"));
  };

  function setBodyHeight() {
  	if (/iPad/i.test(navigator.userAgent) && $('.new-message')[0]) {
  		let z = 450 - ($('body').height() - $('.new-message').position().top);
      let that = this;

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

  function resizeWindow(div) {
  	let window_height = $(window).height();
  	let size;

  	if ($("#activity-messages").length) {
  		size = .25
  	} else {
  		size = .45
  	}
  	let content_height = window_height * size;
  	$(div).height(content_height);
  };

  function setActiveClass() {
  	$('input').focus(function(){
  		let label = $("label[for='"+ $(this).attr('id') + "']")

  		label.addClass("active");

  		$(this).focusout(function () {
  			if (!$(this).val()) {
  				label.removeClass("active")
  			}
  		})
  	})
  };

  function highlightTopic() {
  	$('.topics > a:first-child').addClass('lighten-3')

  	$('.topics > a').not(".next-topic").on('click', function () {
  		$('.topics > a').removeClass('lighten-3')
  		$(this).addClass('lighten-3')
  	})
  };

  function setInitDefaults() {
    responsiveMedia();
    resizeWindow('.messages');
    resizeWindow('#map');
    scrollBottom('.messages');
    highlightTopic();
    setBodyHeight()
    setActiveClass();
  };

  function setChangeTopicDefaults() {
    setBodyHeight();
    responsiveMedia();
    resizeWindow(".messages");
    scrollBottom(".messages");
  }

  return {
    setInitDefaults: setInitDefaults,
    setChangeTopicDefaults: setChangeTopicDefaults,
    resizeWindow: resizeWindow,
    highlightTopic: highlightTopic
  }
}())
