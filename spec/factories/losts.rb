require 'faker'

FactoryGirl.define do
  factory :lost do
    item_number { Faker::Number.number(8) }
    bib_number { Faker::Number.number(8) }
    location 'ula'
  end
end
