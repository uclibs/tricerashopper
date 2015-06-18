# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    title "MyString"
    author "MyString"
    format "MyString"
    publication_date "1999"
    isbn "NyString"
    publisher "MyString"
    oclc 1
    edition "MyString"
    selector "MyString"
    requestor "MyString"
    location_code "MyString"
    fund "MyString"
    added_edition false
    added_copy false
    added_copy_call_number "MyString"
    cost 3214
    currency 'USD'
    rush_order false
    notify false
    reserve false
    notification_contact "MyString"
    relevant_url "MyString"
    other_notes "MyString"
  end
end
