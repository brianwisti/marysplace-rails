# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

points_entry_types =  []
$entryTypeTypeahead = $('.pointsentrytype-typeahead')

$.getJSON '/points_entry_types/unpaged.json', (data) ->
    points_entry_types = $.grep(data, (item) -> item.is_active == true)
    points_entry_types = $.map(points_entry_types, (item) -> item.name)
    $entryTypeTypeahead
      .typeahead(source: points_entry_types)
      .change () ->
        selected_name = $(this).val()
        selected = $.grep(data, (points_entry_type, i) -> points_entry_type.name == selected_name)[0]
        if selected
          selected_id = selected.id
          data_field = $(this).data('field')
          $("##{data_field}").val(selected_id)
          points = selected.default_points
          points_field = $(this).data('pointsfield')
          $("##{points_field}").val(points)
            .data('default', points)
            .change()
    $('.bailed').change () ->
      field = "##{$(this).data('field')}"
      if $(this).is ':checked'
        penalty = $(this).data('penalty')
        default_points = $(field).data('default')
        value = -1 * (penalty + default_points)
        $(field).val value
      else
        default_points = $(field).data 'default'
        $(field).val default_points
      $(field).change()
    $('#points_entry_points_entered').change () ->
      entry_value = parseInt $(this).val()
      multiple = parseInt $('#points_entry_multiple').val()
      initial_balance = parseInt $('.point-balance').html().digits()
      new_total = (entry_value * multiple) + initial_balance
      $('.new-balance').html new_total.commafy()
    $('#points_entry_multiple').change () ->
      multiple = parseInt $(this).val()
      points_entered = parseInt $('#points_entry_points_entered').val()
      initial_balance = parseInt $('.point-balance').html().digits()
      new_total = (points_entered * multiple) + initial_balance
      $('.new-balance').html new_total.commafy()
