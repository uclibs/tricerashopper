# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :problem do
    title "MyString"
    record_type "o"
    record_num 12345678
    description "MyText"
  end
end
