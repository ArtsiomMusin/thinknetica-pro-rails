# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('form#edit-question-form').show()
  $('.comment-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('form#comment-question-form').show()

votes_rating_question = ->
  $('.voting-question').bind 'ajax:success', (e, data, status, xhr) ->
    votes_info = $.parseJSON(xhr.responseText);
    if(votes_info.rating != '+0')
        $('.vote-rating-question').html('<p>' + votes_info.rating + '<p>')
    else
        $('.vote-rating-question').html('')
    $('.voting-choice-question').hide()
    $('.voting-reject-question').show()
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.vote-message-question').html(value)
votes_reject_question = ->
  $('.voting-reject-question').bind 'ajax:success', (e, data, status, xhr) ->
    votes_info = $.parseJSON(xhr.responseText);
    if(votes_info.rating != '+0')
        $('.vote-rating-question').html('<p>' + votes_info.rating + '<p>')
    else
        $('.vote-rating-question').html('')
    $('.voting-choice-question').css('display', 'inline-block')
    $('.voting-reject-question').hide()
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.vote-message-question').html(value)

comment_question = ->
  $('form#comment-question-form').bind 'ajax:success', (e, data, status, xhr) ->
    comment = $.parseJSON(xhr.responseText);
    $('.comments-' + comment.commentable_type.toLowerCase() + '-' + comment.commentable_id).append('<p>' + comment.body + '<p>')
    $('.comment-question-link').show()
    $('#comment_body').val('')
    $('form#comment-question-form').hide()
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.comment-message').html(value)

$(document).ready(ready)
$(document).on("turbolinks:load", ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on('turbolinks:load', votes_rating_question)
$(document).on('turbolinks:load', votes_reject_question)
$(document).on('turbolinks:load', comment_question)

# subscribes here
PrivatePub.subscribe "/questions", (data, channel) ->
  question = $.parseJSON(data['question']);
  $('.questions').append('<p>Question:</p>');
  $('.questions').append('<p><a href="/questions/' + question.id + '">' + question.title + '</a></p>');
