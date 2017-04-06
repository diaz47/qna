require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:questions) }
  it { should have_many(:autharizations) }

  describe '.find_for_oauth' do
    let!(:user){ create(:user) }
    let(:auth){ OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345678')}
    context 'user has already autharization' do
      it 'return user' do
        user.autharizations.create(provider: 'facebook', uid: '12345678')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'context user has not autharization' do
      context 'user already exists' do
        let(:auth){ OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345678', info: { email: user.email}) }

        it 'do not create new user' do
          expect { User.find_for_oauth(auth)}.to_not change(User, :count)
        end

        it 'create authorization to user' do
          expect { User.find_for_oauth(auth)}.to change(user.autharizations, :count).by(1)
        end

        it 'create autharizations with provider and uid' do
          autharization = User.find_for_oauth(auth).autharizations.first
          expect(autharization.provider).to eq auth.provider
          expect(autharization.uid).to eq auth.uid
        end

        it 'return user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user do not exists' do
        let(:auth){ OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345678', info: { email: "newq@mail.ru"}) }

        it 'create new user' do
          expect{User.find_for_oauth(auth)}.to change(User, :count).by(1)
        end
        it 'return user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end
        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end
        it 'create new autharization for user' do
          user = User.find_for_oauth(auth)
          expect(user.autharizations).to_not be_empty
        end

        it 'check autharization provider and uid' do
          autharization = User.find_for_oauth(auth).autharizations.first
          expect(autharization.provider).to eq auth.provider
          expect(autharization.uid).to eq auth.uid
        end

      end
    end
  end

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
