class Radar < ApplicationRecord
  has_many :targets, dependent: :destroy
  has_many :tasks, dependent: :destroy

  validates :title, presence: true
  validates :frame_height, presence: true, numericality: true
  validates :frame_width, presence: true, numericality: true
  validates :frame_symbols, presence: true, length: { minimum: 2 }
end
