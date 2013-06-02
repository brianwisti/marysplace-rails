# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#

autoSubmit = (evt) ->
  if this.value.length >= 8
    $('#login-form').submit()

$('#login')
  .keyup(autoSubmit)
  .focus()
