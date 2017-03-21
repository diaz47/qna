require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many :attachments }
  it { should have_many :votes}
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :attachments }

  describe 'select best answer' do
    let(:question) { create(:question)}
    let(:answer) { create(:answer, question: question)}
    

    it 'answer should be best' do
      answer.set_best_answer

      expect(answer).to be_best_answer
    end

    it 'prev answer should be not best' do
      prev_answer =  create(:answer, question: question, best_answer: true)
      answer.set_best_answer
      prev_answer.reload

      expect(prev_answer).to_not be_best_answer
    end
  end
end
