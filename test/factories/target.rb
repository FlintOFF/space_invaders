FactoryBot.define do
  factory :target do
    radar
    title { 'Target #1' }
    description { 'Description for target' }
    kind { :enemy }
    frame { [['o']] }
  end
end
