ready = ->
  $('.edit_question_link').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('form.question_form').show()
  $('.create_comment').click (e) ->
    $(this).hide();
    question_id = $(this).data('questionId');
    $("#comment_form_question_"+question_id).show();
    $("#comment_form_question_"+question_id).submit (e) ->
      $('.create_comment').show();
      $(this).hide();

  $('.vote_for, .vote_against, .back_vote').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);
    $(".question_sum").html("Rating question: " + response.rating);

  $('form.question_form').submit (e) ->
      $(this).hide()
      $('.edit_question_link').show()
  $('.comment_form').bind 'ajax:success', (e, data, status, xhr) ->
    res = $.parseJSON(xhr.responseText);
    field = res.commentable_type+'_'+res.commentable_id+'_comment';
    $('#'+field).append("<li>"+res.body+"</li>");
    $('#comment_body').val('');


$(document).on('turbolinks:load', ready)

App.cable.subscriptions.create('QuestionsChannel', {
  connected: ->
    @perform 'follow'
  ,
  received: (data)->
    $('.questions_list').append(data)
})
App.cable.subscriptions.create('CommentsChannel', {
  connected: ->
    @perform 'follow'
  ,
  received: (data)->
    comment = data.comment
    field = comment.commentable_type.toLowerCase() + '_' + comment.commentable_id + '_comment'
    if gon.user_id == comment.user_id 
      return false 

    $('#'+field).append(JST['templates/comment']({
      comment: comment
    }));  
})