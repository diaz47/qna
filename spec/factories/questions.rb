FactoryGirl.define do
  factory :question do
    title "MyString"
    body "MyText"
  end
  factory :ivalid_question, class: 'Question' do
    title nil
    body nil
  end
end
