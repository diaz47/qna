require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should validate_presence_of :body }

  describe 'select best answer' do
    let(:question) { create(:question)}
    let(:answer) { create(:answer, question: question)}
    let(:prev_answer) { create(:answer, question: question, best_answer: true)}

    it 'answer should be best' do
      answer.set_best_answer
      expect(answer.best_answer).to eq true
    end

    it 'prev answer should be not best' do
      answer.set_best_answer
      prev_answer.reload

      expect(prev_answer.best_answer).to eq false
    end
  end
end
