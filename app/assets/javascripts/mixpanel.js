$(document).ready(function () {
  $('.signed-up').click(function(){
    mixpanel.track("Signed/Logged In")
  })

  if ($(".home.landing").length) {
    mixpanel.track("Viewed landing")
  }

  if ($(".home.faq").length) {
    mixpanel.track("Viewed FAQ")
  }
})
