require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  let(:user){ create(:user) }
  let!(:questions){ create_list(:question, 3) }
  let(:mail) { DailyMailer.digest(user) }

  it 'renders receiver email' do
    expect(mail.to).to include user.email
  end

  it 'question title in body' do
    questions.each do |question|
      expect(mail.body).to have_content(question.title)
    end
  end
end
