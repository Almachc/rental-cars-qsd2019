class CarRental < ApplicationRecord
  belongs_to :rental
  belongs_to :car

  validates :price, presence: true
  validates :start_mileage, presence: true
end