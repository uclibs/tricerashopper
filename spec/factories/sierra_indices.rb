# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sierra_index do
    record_type "b"
    record_num 12345678
    last_checked "2015-03-14 15:15:30"
  end
end
