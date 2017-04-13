FactoryGirl.define do
  factory :oauth_application, class: Doorkeeper::Application do
    name "TEST"
    redirect_uri "urn:ietf:wg:oauth:2.0:oob"
    uid '1231231'
    secret '21313213'
  end
end