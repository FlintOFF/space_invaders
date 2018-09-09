FactoryBot.define do
  factory :task do
    user
    radar
    frame { [['-', '-'], ['o', 'o']] }
  end
end