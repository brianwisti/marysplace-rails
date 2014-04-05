# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

clients = []

typeahead_options =
  url: '/clients/search.json'
  method: 'get'
  displayField: 'current_alias'
  preDispatch: (query) ->
    return {
      q: query
    }
  preProcess: (data) ->
    if data.success == false
      return false
    clients = data
    return data

$clientTypeahead = $('.client-typeahead')
if $clientTypeahead.length > 0
  $clientTypeahead
  .typeahead(ajax: typeahead_options)
  .change () ->
    selected_alias = $(this).val()
    selected = $.grep(clients, (client, i) -> client.current_alias == selected_alias)[0]
    if selected
      selected_id = selected.id
      if selected_id
        data_field = $(this).data('field')
        $("##{data_field}").val(selected_id)
        $(this).data('balance', selected.point_balance)
        $('.point-balance').html(String(selected.point_balance).commafy())
        if selected.is_flagged == true
          $('.is-flagged').show()
          $('.is-flagged a').attr('href', "/clients/#{selected_id}/flags")
          if selected.can_shop == true
            console.log "Shopping is okay"
            $('.shopping-blocked-label').hide()
          else
            $('.shopping-blocked-label').show()
            console.log "Shopping is verboten"
        else
          $('.is-flagged').hide()
