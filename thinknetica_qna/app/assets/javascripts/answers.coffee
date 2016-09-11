# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()
# answers = ->
#   $('form.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
#     answer = $.parseJSON(xhr.responseText)
#     $('.answers').append(answer.body)
#     $('#answer_body').val('')
#   .bind 'ajax:error', (e, xhr, status, error) ->
#     errors = $.parseJSON(xhr.responseText)
#     $.each errors, (index, value) ->
#       $('.answer-message').html(value)


$(document).ready(ready)
$(document).on("turbolinks:load", ready)
$(document).on('page:load', ready)
#$(document).on('turbolinks:load', answers)
$(document).on('page:update', ready)
