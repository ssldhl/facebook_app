# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  search_result.setupForm()

search_result =
  setupForm: ->
    $('#search-form').submit (event) ->
      $(".ajax_indicator").show()
      $(".error").hide()
      $(".content").hide()