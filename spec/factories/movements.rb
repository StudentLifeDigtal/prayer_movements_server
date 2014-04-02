FactoryGirl.define do
  factory :movement do
    name "Google"
    founded "2014-03-25"
    founder "MyString"
    short_description "MyText"
    long_description "MyText"
    mission "MyText"
    phone "MyString"
    email "my@google.com"
    website "http://www.google.com"
    privacy "open"
  end
end
