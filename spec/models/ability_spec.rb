require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability){ Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }
    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other){ create :user }

    let(:question_user) { create :question, user: user }
    let(:answer_user) { create :answer, user: user, question: question_user }

    let(:question_other) { create :question, user: other }
    let(:answer_other) { create :answer, user: other, question: question_other }

    let(:user_sub){ create(:subscribe, user: user, question: question_user)}

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Subscribe }


    it { should be_able_to :destroy, user_sub }

    it { should be_able_to :update, create(:question, user: user), user: user}
    it { should_not be_able_to :update, create(:question, user: other), user: user}

    it { should be_able_to :update, create(:answer, user: user), user: user}
    it { should_not be_able_to :update, create(:answer, user: other), user: user}


    it { should be_able_to :destroy, create(:question, user: user), user: user}
    it { should_not be_able_to :destroy, create(:question, user: other), user: user}

    it { should be_able_to :destroy, create(:answer, user: user), user: user}
    it { should_not be_able_to :destroy, create(:answer, user: other), user: user}

    it { should be_able_to :destroy, create(:attachment, attachable: question_user), user: user}
    it { should_not be_able_to :destroy, create(:attachment, attachable: answer_other), user: user}

    context 'API' do
      it { should be_able_to :me, user }
      it { should_not be_able_to :me, other }
    end

  end
end
