FactoryGirl.define do
  sequence :email do |n|
    "userываывфываыв2#{n}@test2.ru"
  end

  factory :user do
    email 
    password '12345678'
    password_confirmation '12345678'
  end

  factory :user_2, class: "User" do
    email 'tsdfы123w@mail2.ru'
    password '12345678'
    password_confirmation '12345678'
  end
end
