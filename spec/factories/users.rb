FactoryGirl.define do
  sequence :email do |n|
    "usermail#{n}@mail.ru"
  end

  factory :user do
    email
    password '12345678'
    password_confirmation '12345678'
  end

  factory :user_2, class: "User" do
    email 'tsdf@mail.ru'
    password '12345678'
    password_confirmation '12345678'
  end
end
