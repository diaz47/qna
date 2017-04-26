require 'rails_helper'

RSpec.describe DailyJob, type: :job do
  let(:users){ create_list(:user, 2) }

  it 'sent mail for users' do
    users.each do |user|
      expect(DailyMailer).to receive(:digest).with(user).and_call_original
    end
    DailyJob.perform_now
  end
end
