class Car < ApplicationRecord
  belongs_to :car_model

  enum status: { available: 0, unavailable: 5 }

  def full_description
    "#{car_model.manufacturer.name} / #{car_model.name} - #{license_plate} - #{color}"
  end
end