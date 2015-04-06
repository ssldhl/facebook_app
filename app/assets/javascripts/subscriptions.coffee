# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  subscription.setupForm()

subscription =
  setupForm: ->
    $('#payment-form').submit (event) ->
      form = $(this)
      form.find("input[type=submit]").attr 'disabled', true
      Stripe.card.createToken form, subscription.stripeResponseHandler
      false

  stripeResponseHandler: (status, response) ->
    form = $('#payment-form')
    if response.error
      # Show the errors on the form
      form.find('.payment-errors').text response.error.message
      form.find("input[type=submit]").attr 'disabled', false
    else
      # response contains id and card, which contains additional card details
      token = response.id
      # Insert the token into the form so it gets submitted to the server
      form.append $('<input type="hidden" name="stripeToken" />').val(token)
      # and submit
      form.get(0).submit()