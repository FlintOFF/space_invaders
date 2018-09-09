FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { 'super_password' }
    admin { false }
  end
end