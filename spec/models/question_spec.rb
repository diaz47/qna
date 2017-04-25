require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many :attachments }
  it { should have_many :comments }
  it { should have_many :votes}
  it { should belong_to :user }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :attachments }
  it { should have_many :subscribes }

  describe '#subscribe_author' do
    let(:user){ create :user }
    let(:question) { build :question, user: user }

    it 'auto subscribe author to his question ' do
      expect{ question.save }.to change(user.subscribes, :count).by(1)
    end

    it 'run subscribe_author method when question save' do
      expect(question).to receive(:subscribe_author)
      question.save!
    end
  end
end
