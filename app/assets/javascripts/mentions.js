function mentions() {
  function mentioning() {
    var data = $('.messages').data("namesdata");
    at_config = {
      at: "@",
      displayTpl: "<li>${name} <small>${full_name}</small></li>",
      insertTpl: '<span data-name="${slug}">@${name}</span>',
      data: data
    }

    $('.atwho-container').remove()
    $('.new-message').atwho(at_config);
  };

  return {
    mentioning: mentioning
  };
}
