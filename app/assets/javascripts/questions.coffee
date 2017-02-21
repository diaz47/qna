$ ->
  $('.edit_question_link').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('form.question_form').show()

  $('form.question_form').submit (e) ->
      $(this).hide()
      $('.edit_question_link').show()

