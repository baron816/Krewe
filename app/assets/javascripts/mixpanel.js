$(document).ready(function () {
  $('.new_beta_code').submit(function () {
    mixpanel.track("Submitted Email")
  })

  $('.new_user').submit(function () {
    mixpanel.track("Finished Signup")
  })
})
