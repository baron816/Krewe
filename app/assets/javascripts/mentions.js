function mentioning(dataHash) {
  var data = dataHash;
  at_config = {
    at: "@",
    displayTpl: "<li>${name} <small>${full_name}</small></li>",
    insertTpl: '<span data-name="${slug}">@${name}</span>',
    data: data
  }

  $('.atwho-container').remove()
  $('.new-message').atwho(at_config);
}
