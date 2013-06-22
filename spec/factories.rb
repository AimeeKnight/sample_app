FactoryGirl.define do
  factory :user do #uses the User class
    name     "Michael Hartl"
    email    "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end