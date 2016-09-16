# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

PrivatePub.subscribe "/comments/question", (data, channel) ->
  comment = $.parseJSON(data['comment']);
  $('.comments-' + comment.commentable_type.toLowerCase() + '-' + comment.commentable_id).append('<p>' + comment.body + '<p>')
  $('.comment-question-link').show()
  $('#comment_body').val('')
  $('form#comment-question-form').hide()

PrivatePub.subscribe "/comments/answer", (data, channel) ->
  comment = $.parseJSON(data['comment']);
  $('.comments-' + comment.commentable_type.toLowerCase() + '-' + comment.commentable_id).append('<p>' + comment.body + '<p>')
  $('.comment-answer-link').show()
  $('#comment_body').val('')
  $('form#comment-answer-form').hide()
