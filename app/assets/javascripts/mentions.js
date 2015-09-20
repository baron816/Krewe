function mentioning(dataHash) {
  data = dataHash;
  $('.new-message').atwho({
    at: "@",
    displayTpl: '<li>${first_name} <small>${full_name}</small></li>',
    insertTpl: '<a href="/users/${slug}/public_profile" data-name="${slug}">@${first_name}</a>',
    data: data
  })
}
