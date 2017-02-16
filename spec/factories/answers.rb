FactoryGirl.define do
  sequence :body do |n|
    "body#{n}"
  end
  factory :answer do
    body 
    user
    question
  end

  factory :invalid_answer, class: "Answer" do
    body nil
    user
    question
  end
end
