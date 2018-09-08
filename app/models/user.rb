class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy


  validates :email, uniqueness: { case_sensitive: false }, presence: true
end
