# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email 'user@users.com'
  end

  factory :assistant, class: Assistant, parent: :user do
    selector_id 1
  end
  
  factory :selector, class: Selector, parent: :user do
    lmlo_receives_report true
    location ['ula', 'ucr']
  end
end
