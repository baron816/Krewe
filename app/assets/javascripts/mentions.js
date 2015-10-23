function mentioning(dataHash) {
  var data = dataHash;
  var at_config = {
    at: "@",
    displayTpl: "<li>${name} <small>${full_name}</small></li>",
    insertTpl: '<a href="/users/${slug}/public_profile" data-name="${slug}">@${name}</a>',
    data: data
  }

  $('.atwho-container').remove()
  $('.new-message').atwho(at_config);
}
