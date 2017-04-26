require 'rails_helper'

RSpec.describe SubJob, type: :job do
  let!(:author){ create(:user) }
  let!(:sub_user){ create(:user) }
  let!(:unsub_user){ create(:user) }

  let(:question){ create(:question, user: author) }
  let(:answer){ create(:answer, question: question, user: author) }

  let!(:subscribe_author){ create(:subscribe, user: author, question: question) }
  let!(:subscribe_user){ create(:subscribe, user: sub_user, question: question) }

  it 'send mail for sub users' do
    subscribe_author
    subscribe_user

    expect(SubscriberMailer).to receive(:question_mail).with(author.email, answer).and_call_original
    expect(SubscriberMailer).to receive(:question_mail).with(sub_user.email, answer).and_call_original
    SubJob.perform_now(answer)
  end

  it 'send not for not sub users' do
    expect(SubscriberMailer).to_not receive(:question_mail).with(unsub_user.email, answer).and_call_original
    SubJob.perform_now(answer)
  end
end
