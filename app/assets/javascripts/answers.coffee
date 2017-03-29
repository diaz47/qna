ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();
  $('.create_comment').click (e) ->
    $(this).hide();
    answer_id = $(this).data('answerId');
    $("#comment_form_answer_"+answer_id).show();
    $("#comment_form_answer_"+answer_id).submit (e) ->
      $('.create_comment').show();
      $(this).hide();

  $('.vote_for, .vote_against, .back_vote').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);
    $('#answer_sum_'+ response.id).html("Rating answer: " + response.rating);

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      questionId = $('.question').data(questionId)
      @perform 'follow', id: questionId.questionId
    ,
    received: (data)->
      if gon.user_id == data.answer.user_id 
        return false 
      $('.answer_list ul').append(JST['templates/answer']({
        answer: data.answer,
        question: data.question,
        attachments: data.attachments,
        rating: data.rating
      }));
  });
$(document).on('turbolinks:load', ready)