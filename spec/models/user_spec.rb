require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:questions) }

  describe "author_of?" do
    let(:author) { create(:user) }
    let(:user) { create(:user) }

    let(:question) { create(:question, user: author) }
    let(:answer) { create(:answer, question: question, user: author)}

    context 'user_id == object_id' do
      it "user_id == question_id" do
        expect(author.author_of?(question)).to eq true
      end

      it "user_id == answer_id" do
        expect(author.author_of?(answer)).to eq true
      end
    end

    context 'user_id != object_id ' do
      it "user_id != question_id" do
        expect(user.author_of?(question)).to eq false
      end

      it "user_id != answer_id" do
        expect(user.author_of?(answer)).to eq false
      end
    end
  end
end
