# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

items = []
$itemName = $('.catalog-item-typeahead')
initial_balance = $itemName.data('balance')

$.getJSON '/catalog_items.json', (data) ->
  catalog_items = $.grep(data, (item) -> item.is_available == true)
  items = $.map(catalog_items, (item) -> item.name)
  $itemName
    .typeahead(source: items)
    .change () ->
      selected_name = $(this).val()
      selected = $.grep(data, (item, i) -> item.name == selected_name)[0]
      if selected
        selected_id = selected.id
        data_field = $(this).data('field')
        $("##{data_field}").val(selected_id)
        cost = selected.cost
        cost_field = $(this).data('pointsfield')
        $("##{cost_field}").val(cost).change()
  $('item_cost').change () ->
    entry_value = parseInt $(this).val()
    balance = initial_balance - entry_value
    console.log(balance)
