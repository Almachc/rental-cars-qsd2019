class CarModel < ApplicationRecord
  belongs_to :manufacturer
  belongs_to :car_category
  has_many :cars

  validates :name, presence: true
  validates :year, presence: true
  validates :manufacturer_id, presence: true
  validates :motorization, presence: true
  validates :car_category_id, presence: true
  validates :fuel_type, presence: true
end
