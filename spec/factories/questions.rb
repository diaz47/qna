FactoryGirl.define do
  sequence :title do |n|
    "title#{n}"
  end
  factory :question do
    title
    body "MyText"
    user
  end 
  factory :ivalid_question, class: 'Question' do
    title nil
    body nil
    user
  end
end
