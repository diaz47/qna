FactoryGirl.define do
  factory :comment do
    user
    body "comment"

    trait :for_question do
      association :commentable, factory: :question
      attachable_type 'Question'
    end

    trait :for_answer do
      association :commentable, factory: :answer
      attachable_type 'Answer'
    end
  end
end
