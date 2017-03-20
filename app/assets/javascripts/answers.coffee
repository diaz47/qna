ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();

  $('.vote_for, .vote_against, .back_vote').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);
    $('#answer_sum_'+ response.id).html("Rating answer: " + response.rating);
$(document).on('turbolinks:load', ready)