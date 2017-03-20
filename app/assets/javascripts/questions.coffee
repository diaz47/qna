ready = ->
  $('.edit_question_link').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('form.question_form').show()

  $('.vote_for, .vote_against, .back_vote').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);
    $(".question_sum").html("Rating question: " + response.rating);

  $('form.question_form').submit (e) ->
      $(this).hide()
      $('.edit_question_link').show()
$(document).on('turbolinks:load', ready)

