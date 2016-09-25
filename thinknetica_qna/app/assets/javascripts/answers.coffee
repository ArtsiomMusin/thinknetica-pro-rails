# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()
  $('.comment-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('form#comment-answer-form').show()

votes_rating_answer = ->
  $('.voting-answer').bind 'ajax:success', (e, data, status, xhr) ->
    votes_info = $.parseJSON(xhr.responseText);
    if(votes_info.rating != '+0')
        $('.vote-rating-answer-' + votes_info.id).html('<p>' + votes_info.rating + '<p>')
    else
        $('.vote-rating-answer-' + votes_info.id).html('')
    $('.voting-choice-answer-' + votes_info.id).hide()
    $('.voting-reject-answer-' + votes_info.id).show()
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.vote-message-answer-' + votes_info.id).html(value)
votes_reject_answer = ->
  $('.voting-reject-answer').bind 'ajax:success', (e, data, status, xhr) ->
    votes_info = $.parseJSON(xhr.responseText);
    if(votes_info.rating != '+0')
        $('.vote-rating-answer-' + votes_info.id).html('<p>' + votes_info.rating + '<p>')
    else
        $('.vote-rating-answer-' + votes_info.id).html('')
    $('.voting-choice-answer-' + votes_info.id).css('display', 'inline-block')
    $('.voting-reject-answer-' + votes_info.id).hide()
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.vote-message-answer-' + votes_info.id).html(value)

comment_answer = ->
  $('form#comment-answer-form').bind 'ajax:error', (e, xhr, status, error) ->
    errors = xhr.responseJSON.errors
    prefix = ''
    if errors.body?
      errors = errors.body
      prefix = 'Body '
    $.each errors, (index, value) ->
      $('.comment-message').html(prefix + value)

$(document).ready(ready)
$(document).on("turbolinks:load", ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on('turbolinks:load', votes_rating_answer)
$(document).on('turbolinks:load', votes_reject_answer)
$(document).on('turbolinks:load', comment_answer)
