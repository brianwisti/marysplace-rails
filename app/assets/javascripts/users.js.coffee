$ ->
  $('.roles-toggler')
    .button()
    .bind 'click', (event) ->
      $clicked = $(event.srcElement)
      user = $clicked.data('user')
      role = $clicked.data('role')
      post_data =
        role_id: role
        user_id: user
      url = "/users/#{user}/toggle_role"
      $.post url, post_data, (response) ->
        message = response.result
        console.log message
        $('.log')
          .addClass('alert')
          .text(message)

