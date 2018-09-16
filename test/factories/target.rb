FactoryBot.define do
  factory :target do
    radar
    sequence(:title) { |n| "Target #{n}" }
    description { 'Description for target' }
    kind { :enemy }
    frame { [['o']] }
  end
end
