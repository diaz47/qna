FactoryGirl.define do
  sequence :title do |n|
    "title#{n}"
  end

  factory :question do
    title
    body "MyText"
    association :user

    factory :question_with_answer, class: 'Question' do
      after(:create) do |question|
        create(:answer, question: question)
      end
    end
    
  end 

  factory :ivalid_question, class: 'Question' do
    title nil
    body nil
    user
  end
end
