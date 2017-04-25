require "rails_helper"

RSpec.describe SubscriberMailer, type: :mailer do
  let(:user){ create :user }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question) }
  let(:mail){ SubscriberMailer.question_mail(user.email, answer) }

  it 'renders receiver email' do
    expect(mail.to).to have_content user.email
  end

  it 'mail have title of question' do
    expect(mail.body).to have_content answer.body
  end

  it 'mail have body of answer' do
    expect(mail.body).to have_content question.title
  end
end
