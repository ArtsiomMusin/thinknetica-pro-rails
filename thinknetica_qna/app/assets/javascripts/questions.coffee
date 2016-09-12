# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('form#edit-question-form').show()

votes_rating = ->
  $('.voting').bind 'ajax:success', (e, data, status, xhr) ->
    votes_info = $.parseJSON(xhr.responseText);
    if(votes_info.rating != '+0')
        $('.vote-rating').html('<p>' + votes_info.rating + '<p>')
    else
        $('.vote-rating').html('')
    $('.voting-choice-action').hide()
    $('.voting-reject-action').show()
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.vote-message').html(value)
votes_reject = ->
  $('.voting-reject').bind 'ajax:success', (e, data, status, xhr) ->
    votes_info = $.parseJSON(xhr.responseText);
    if(votes_info.rating != '+0')
        $('.vote-rating').html('<p>' + votes_info.rating + '<p>')
    else
        $('.vote-rating').html('')
    $('.voting-choice-action').css('display', 'inline-block')
    $('.voting-reject-action').hide()
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.vote-message').html(value)

$(document).ready(ready)
$(document).on("turbolinks:load", ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on('turbolinks:load', votes_rating)
$(document).on('turbolinks:load', votes_reject)
